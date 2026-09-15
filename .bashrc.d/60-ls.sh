# Omarchy's ls is already `eza -lh`; ll adds dotfiles.
alias ll='eza -lah --group-directories-first --icons=auto'
alias l=ll
# ls -lrt: newest at the bottom. eza's modified sort is oldest-first already.
alias lrt='eza -lh --sort=modified --icons=auto'
