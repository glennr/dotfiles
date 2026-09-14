#!/usr/bin/env bash
# Create branch gr/<slug> off master, a worktree under .worktrees/<slug>, and a post skeleton.
# Idempotent: re-running prints the existing paths.
set -euo pipefail
BLOG=${BLOG_DIR:-$HOME/src/glennr/blog}
til=0; title=""; tags=""; slug=""
usage() { sed -n '2,3p' "$0" | sed 's/^# //'; echo; echo "usage: $(basename "$0") <slug> [--til] [--title T] [--tags a,b]"; }
while [ $# -gt 0 ]; do case $1 in
  --til) til=1; shift;; --title) title=$2; shift 2;; --tags) tags=$2; shift 2;;
  -h|--help) usage; exit 0;; -*) echo "unknown: $1" >&2; usage; exit 2;; *) slug=$1; shift;; esac; done
[ -n "$slug" ] || { usage; exit 2; }
[[ $slug =~ ^[a-z0-9-]+$ ]] || { echo "slug must be lowercase kebab-case" >&2; exit 2; }

branch=gr/$slug
wt=$BLOG/.worktrees/$slug
post=$wt/content/posts/$slug.md
mkdir -p "$BLOG/.worktrees"
grep -qx '/.worktrees' "$BLOG/.gitignore" || echo '/.worktrees' >> "$BLOG/.gitignore"

if ! git -C "$BLOG" show-ref --verify --quiet "refs/heads/$branch"; then
  git -C "$BLOG" branch "$branch" master
fi
if [ ! -d "$wt" ]; then
  git -C "$BLOG" worktree add --quiet "$wt" "$branch"
fi
if [ ! -f "$post" ]; then
  [ -n "$title" ] || title=$(echo "$slug" | sed -e 's/^til-//' -e 's/-/ /g' -e 's/^./\U&/')
  [ "$til" = 1 ] && [[ $title != TIL:* ]] && title="TIL: $title"
  cat=$([ "$til" = 1 ] && echo til || echo development)
  taglines=""
  IFS=, read -ra ts <<< "$tags"; for t in "${ts[@]}"; do [ -n "$t" ] && taglines+="  - $t"$'\n'; done
  cat > "$post" <<FM
---
title: "$title"
description: ""
date: $(date +%Y-%m-%dT%H:%M:00%:z)
draft: true
categories:
  - $cat
tags:
$taglines---

FM
fi
echo "branch:   $branch"
echo "worktree: $wt"
echo "post:     $post"
