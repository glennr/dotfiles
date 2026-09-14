#!/usr/bin/env bash
# Digest of recent activity worth blogging about: commits across ~/src and yadm, vault notes,
# Claude plans and session openers. Output is markdown on stdout.
set -euo pipefail

SRC=${BLOG_SRC:-$HOME/src}
VAULT=${BLOG_VAULT:-$HOME/src/glennr/obsidian}
STATE=${XDG_STATE_HOME:-$HOME/.local/state}/blog-drafts
STAMP=$STATE/last-harvest
since=""; stamp=0

usage() { sed -n '2,3p' "$0" | sed 's/^# //'; echo; echo "usage: $(basename "$0") [--since DATE] [--stamp]"; echo "  --since  git/find date (default: last stamp, else 7 days ago)"; echo "  --stamp  record now as the last harvest"; }
while [ $# -gt 0 ]; do case $1 in
  --since) since=$2; shift 2;; --stamp) stamp=1; shift;; -h|--help) usage; exit 0;; *) echo "unknown: $1" >&2; usage; exit 2;; esac; done
if [ -z "$since" ]; then
  if [ -f "$STAMP" ]; then since=$(cat "$STAMP"); else since=$(date -d '7 days ago' +%F); fi
fi

echo "# Harvest since $since ($(date +%F))"
echo
echo "## Already in the backlog"
grep -oE '^\| `[a-z0-9-]+`' "$VAULT/notes/blog backlog.md" 2>/dev/null | tr -d '|` ' | sed 's/^/- /' || echo "- (no backlog note)"
echo
echo "## Commits"
while IFS= read -r gitdir; do
  repo=${gitdir%/.git}
  n=$(git -C "$repo" log --since="$since" --oneline 2>/dev/null | wc -l)
  [ "$n" -gt 0 ] || continue
  echo; echo "### ${repo#$SRC/} ($n)"
  git -C "$repo" log --since="$since" --format='- %h %ad %s' --date=short | head -40
done < <(find "$SRC" -maxdepth 4 -name .git -type d 2>/dev/null | sort)
if command -v yadm >/dev/null; then
  n=$(yadm log --since="$since" --oneline 2>/dev/null | wc -l)
  if [ "$n" -gt 0 ]; then echo; echo "### yadm ($n)"; yadm log --since="$since" --format='- %h %ad %s' --date=short | head -40; fi
fi
echo
echo "## Vault notes modified"
find "$VAULT" -name '*.md' -newermt "$since" -not -path '*/.obsidian/*' -not -path '*/.git/*' -printf '- %P\n' | sort
echo
echo "## Plans"
find "$HOME/.claude/plans" -name '*.md' -newermt "$since" 2>/dev/null | while read -r f; do
  printf -- '- %s: %s\n' "$(basename "$f" .md)" "$(grep -m1 '^# ' "$f" | sed 's/^# //')"
done
echo
echo "## Claude sessions (first user message)"
find "$HOME/.claude/projects" -maxdepth 2 -name '*.jsonl' -newermt "$since" 2>/dev/null | sort | while read -r f; do
  first=$(grep -m1 '"type":"user"' "$f" | python3 -c '
import sys,json
try:
    o=json.loads(sys.stdin.readline()); c=o["message"]["content"]
    t=c if isinstance(c,str) else " ".join(x.get("text","") for x in c if isinstance(x,dict))
    print(" ".join(t.split())[:240])
except Exception: print("?")')
  case $first in '<'*|'?'|'') continue;; esac
  printf -- '- %s %s %sK: %s\n' "$(basename "$(dirname "$f")")" "$(basename "$f" .jsonl | cut -c1-8)" "$(du -k "$f" | cut -f1)" "$first"
done
if [ "$stamp" = 1 ]; then mkdir -p "$STATE"; date +%F > "$STAMP"; echo; echo "(stamped $STAMP)"; fi
