# Working clone of this repo. yadm deploys the same commits into $HOME.
# Edit in the clone, not in $HOME: it holds only the managed files, so
# `git add -A` there cannot pick up anything Omarchy owns.
alias dot='cd ~/src/glennr/dotfiles'
alias dots='git -C ~/src/glennr/dotfiles status --short; yadm status --short'
alias dotsync='git -C ~/src/glennr/dotfiles fetch yadm && git -C ~/src/glennr/dotfiles reset --hard yadm/omarchy'
alias dotdeploy='yadm fetch ~/src/glennr/dotfiles omarchy && yadm merge --ff-only FETCH_HEAD'
