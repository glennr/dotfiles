# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Personal PATH entries, above the interactive guard so `bash -lc` and ssh
# remote commands see them too
[[ -d "$HOME/.bin" ]] && export PATH="$HOME/.bin:$PATH"
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Personal config. Numbered so ordering stays explicit: 50 must run after
# Omarchy's rc but before 90 sources the aliases that shadow ga/gd.
for f in ~/.bashrc.d/*.sh; do [[ -r $f ]] && source "$f"; done
