# Shared history across terminals
shopt -s histappend
HISTCONTROL=ignoredups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
