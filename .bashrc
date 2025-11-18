# Omakub default config
# initalizes mise etc.
source ~/.local/share/omakub/defaults/bash/rc

# Override Omakub
# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Starship.rs powered prompt
eval "$(starship init bash)"

source ~/.local/share/blesh/ble.sh

[[ -f ~/.aliases ]] && source ~/.aliases

export AWS_SESSION_TOKEN_TTL=4h
export AWS_ASSUME_ROLE_TTL=4h

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Enable shared history between terminals
shopt -s histappend                # Append to the history file, don't overwrite
export HISTCONTROL=ignoredups      # Ignore duplicate commands in history
export HISTSIZE=50000              # Set the history size
export HISTFILESIZE=100000          # Set the history file size
export HISTTIMEFORMAT="%F %T "     # Add timestamp to each history entry

# Flush history after each command
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

export PATH=~/.bin:$PATH

# Remap numpad Enter to regular Enter
xmodmap ~/.Xmodmap 2>/dev/null

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/g/.lmstudio/bin"

# workaround for https://github.com/RooVetGit/Roo-Code/issues/1377
# https://docs.roocode.com/troubleshooting/shell-integration/#steps-to-change-the-execution-policy
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"

# Smart cd: prefer real paths, then zoxide (cwd-scoped, then global)
zcwd() {
  # No args: normal "cd" to $HOME
  if [ $# -eq 0 ]; then
    builtin cd || return
    return
  fi

  # First, try normal cd behaviour (rel/abs paths, cd -, cd .., etc.)
  if builtin cd "$@" 2>/dev/null; then
    return
  fi

  # If that failed, try zoxide, scoped to current directory
  local target

  if target="$(zoxide query --cwd "$PWD" -- "$@" 2>/dev/null)"; then
    builtin cd "$target" || return
    return
  fi

  # Fall back to global zoxide ranking
  if target="$(zoxide query -- "$@" 2>/dev/null)"; then
    builtin cd "$target" || return
    return
  fi

  # Nothing worked
  printf 'cd: no such file or directory (and no zoxide match): %s\n' "$*" >&2
  return 1
}

# Override Omakub's cd='z' alias with zcwd
alias cd='zcwd'
