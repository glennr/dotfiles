source ~/.local/share/omakub/defaults/bash/rc

# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Starship.rs powered prompt
eval "$(starship init bash)"

source ~/.local/share/blesh/ble.sh
