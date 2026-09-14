#!/usr/bin/env bash
# Voice and AI-tell lint for a post. Reports line:rule:text. Code blocks and frontmatter are
# skipped. Exit 1 on any hit. Runs vale afterwards if installed.
set -uo pipefail
usage() { sed -n '2,3p' "$0" | sed 's/^# //'; echo; echo "usage: $(basename "$0") <file>..."; }
[ $# -gt 0 ] || { usage; exit 2; }
[ "$1" = -h ] || [ "$1" = --help ] && { usage; exit 0; }
rc=0
for f in "$@"; do
  [ -f "$f" ] || { echo "$f: no such file" >&2; rc=1; continue; }
  hits=$(python3 - "$f" <<'PY'
import re,sys
path=sys.argv[1]; lines=open(path,encoding="utf-8").read().split("\n")
stock=r"\b(delve|delves|seamless(ly)?|leverage[sd]?|robust|crucial|pivotal|tapestry|testament|elevate[sd]?|streamlined?|game-changer|game changer|unlock(s|ed)?|harness(es|ed)?|journey|realm|landscape|foster(s|ed)?|underscore[sd]?|holistic|synerg\w+|cutting-edge|world-class|empower(s|ed)?|navigate[sd]?|multifaceted|vibrant|meticulous(ly)?|comprehensive)\b"
phrases=r"(it'?s worth noting|in today'?s|at its core|let'?s dive|dive into|deep dive|in conclusion|to summarize|in summary|the bottom line|game.changing|whether you'?re|look no further|i hope this helps|happy \w+ing!|without further ado|a testament to|stands? as a|serves? as a|plays? a (crucial|vital|key) role)"
notbut=r"\bnot (just|only|merely|simply)?\s*\w+[^.;:]{0,60}\bbut (rather |also |instead )?\b|\bisn'?t (just |only |about )?[^.;]{0,50}\b(it'?s|it is) \b|\bit'?s not (about|a matter of)\b"
emoji=re.compile("[\U0001F300-\U0001FAFF☀-➿\U0001F000-\U0001F2FF]")
infm=False; incode=False; out=[]
for i,l in enumerate(lines,1):
    if i==1 and l.strip()=="---": infm=True; continue
    if infm:
        if l.strip()=="---": infm=False
        continue
    if l.strip().startswith("```"): incode=not incode; continue
    if incode: continue
    s=re.sub(r"`[^`]*`","",l)  # strip inline code
    def hit(rule,txt=None): out.append(f"{i}:{rule}:{(txt or l).strip()[:110]}")
    if "—" in s: hit("em-dash")
    if "–" in s: hit("en-dash")
    if re.search(r"\s-\s*$",s) or re.search(r"\w-\s\w",s) and False: hit("dash")
    if emoji.search(s): hit("emoji")
    if re.search(r"^\s*([-*]|\d+\.)?\s*\*\*[^*]{1,60}\*\*\s*[:.]",s): hit("bold-label")
    if re.search(notbut,s,re.I): hit("not-x-but-y")
    if re.search(stock,s,re.I): hit("stock-word:"+re.search(stock,s,re.I).group(0))
    if re.search(phrases,s,re.I): hit("stock-phrase:"+re.search(phrases,s,re.I).group(0))
    m=re.match(r"^(#+)\s+(.*)",s)
    if m:
        words=[w for w in re.split(r"\s+",m.group(2)) if re.match(r"[A-Za-z]",w)]
        caps=[w for w in words[1:] if w[0].isupper() and w.lower() not in ("i",) and not w.isupper()]
        if len(words)>=3 and len(caps)>=len(words)-1: hit("title-case-heading")
    if re.search(r"^\s*(In (short|other words)|Overall|Ultimately|All in all)[,:]",s): hit("closer")
    if re.search(r"\b(\w+), (\w+), and (\w+)\b",s) and len(s)<80 and re.search(r"^\s*[-*]",s): hit("triad?")
print("\n".join(out))
PY
)
  if [ -n "$hits" ]; then echo "$hits" | sed "s|^|$f:|"; rc=1; else echo "$f: clean"; fi
  if command -v vale >/dev/null 2>&1 && [ -f "$(dirname "$f")/../../.vale.ini" ]; then (cd "$(dirname "$f")/../.." && vale --no-wrap "$f" || true); fi
done
exit $rc
