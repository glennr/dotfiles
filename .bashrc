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
