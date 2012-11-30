# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="mgutz"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)

# vi-mode interferes with history-substring-search
plugins=(vi-mode annotate brew bundler gem git git-on-roids github heroku heroku-on-roids history-substring-search rails rails-on-roids rails3 rbenv ruby)
source $ZSH/oh-my-zsh.sh

# Customize to your needs...

export PATH=~/bin:$PATH
### Faves
#export EDITOR='mate -w'
export EDITOR='vi'
#export GIT_EDITOR='mate -wl1'. #This instructs TextMate to open with the caret at line 1 rather than where it last was.
#export GIT_EDITOR='mvim -f'.
#export SVN_EDITOR=vim
setopt hist_ignore_all_dups

#FUCK YOU AUTOCORRECT
unsetopt correct_all


      # Add the following to your ~/.bashrc or ~/.zshrc
      hitch() {
        command hitch "$@"
        if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
      }
      alias unhitch='hitch -u'
      # Uncomment to persist pair info between terminal instances
      hitch

#I  don't like the zsh builtin time command.
[[ -x =time ]] && alias time='command time'

alias hou='cd c/hound'
alias vng='cd c/vng'
alias m='mvim .'
alias siy='cd c/siyelo'
alias hrt='cd ~/c/hrt'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
