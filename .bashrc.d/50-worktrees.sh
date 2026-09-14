# Omarchy's worktree helpers live on ga()/gd(), which .aliases claims for
# git add/diff. Capture them under gw* while they're still the live definitions.
#   gwa <branch>  create ../<repo>--<branch>, mise-trust it, cd in
#   gwd           from inside a worktree: remove it + delete branch (prompts)
declare -F ga >/dev/null && eval "gwa()$(declare -f ga | tail -n +2)"
declare -F gd >/dev/null && eval "gwd()$(declare -f gd | tail -n +2)"
