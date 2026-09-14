# oh-my-zsh Git Aliases

# General Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git pull --rebase'
alias gp='git push'
alias gcl='git clone'
alias gco='git checkout'
alias gd='git diff'
alias gb='git branch'
alias gba='git branch -a'
alias gcb='git checkout -b'
alias gm='git merge'
alias gpo='git push origin'

# Log and Diff Shortcuts
alias glg='git log --graph --oneline --decorate --all'
alias gds='git diff --staged'
alias gdt='git difftool'
alias glp='git log -p'
alias glog='git log --oneline --decorate'

# Commit Aliases
alias gc='git commit -v'
alias gca='git commit -v -a'
# alias gcam='git commit -a -m'
alias gcm='git commit -m'

# Stashing Aliases
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsts='git stash show --text'

# Remote Aliases
alias grm='git remote'
alias grv='git remote -v'
alias gra='git remote add'

# Reset and Clean Aliases
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'

# Fetching and Rebasing Aliases
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfo='git fetch origin'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'

# Custom Functions

# Checkout a branch and create it if it doesn’t exist
gch() {
  git checkout "$1" 2>/dev/null || git checkout -b "$1"
}

# Create a new commit with an "amend" option if desired
gcaamend() {
  git commit -a --amend -m "$1"
}

# Git quick log for recent commits
git_recent() {
  git log --oneline -n "${1:-10}"
}

# Apply all stashes
gstall() {
  git stash apply "$@"
}


