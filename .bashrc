source ~/.local/share/omakub/defaults/bash/rc

# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Starship.rs powered prompt
eval "$(starship init bash)"

source ~/.local/share/blesh/ble.sh

[[ -f ~/.aliases ]] && source ~/.aliases

export AWS_SESSION_TOKEN_TTL=4h
export AWS_ASSUME_ROLE_TTL=4h

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Enable shared history between terminals
shopt -s histappend                # Append to the history file, don't overwrite
export HISTCONTROL=ignoredups      # Ignore duplicate commands in history
export HISTSIZE=50000              # Set the history size
export HISTFILESIZE=100000          # Set the history file size
export HISTTIMEFORMAT="%F %T "     # Add timestamp to each history entry

# Flush history after each command
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

export PATH=~/.bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/g/.lmstudio/bin"

