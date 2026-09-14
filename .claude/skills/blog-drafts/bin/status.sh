#!/usr/bin/env bash
# One line per gr/* draft branch: worktree, post, words, lint, last commit.
set -uo pipefail
BLOG=${BLOG_DIR:-$HOME/src/glennr/blog}
LINT=$(dirname "$0")/lint.sh
[ "${1:-}" = -h ] || [ "${1:-}" = --help ] && { sed -n '2p' "$0" | sed 's/^# //'; exit 0; }
printf '%-52s %-6s %-6s %-8s %s\n' branch words draft lint "last commit"
git -C "$BLOG" for-each-ref --format='%(refname:short)' refs/heads/gr/ | while read -r br; do
  slug=${br#gr/}; wt=$BLOG/.worktrees/$slug
  if [ -d "$wt" ]; then dir=$wt; else dir=$BLOG; fi
  post=$(git -C "$BLOG" diff --name-only master..."$br" -- content/posts | head -1)
  if [ -n "$post" ] && [ -f "$dir/$post" ]; then
    words=$(sed '1,/^---$/{/^---$/!d}' "$dir/$post" | sed '1d' | wc -w)
    draft=$(grep -m1 '^draft:' "$dir/$post" | awk '{print $2}')
    if "$LINT" "$dir/$post" >/dev/null 2>&1; then lint=clean; else lint=$("$LINT" "$dir/$post" 2>/dev/null | grep -c ':'); lint="${lint} hits"; fi
  else words=-; draft=-; lint=-; fi
  last=$(git -C "$BLOG" log -1 --format='%h %s' "$br" 2>/dev/null | cut -c1-50)
  printf '%-52s %-6s %-6s %-8s %s\n' "$br" "$words" "$draft" "$lint" "$last"
done
echo; git -C "$BLOG" worktree list
