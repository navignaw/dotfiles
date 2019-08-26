#===========================
# navignaw's custom bashrc
#===========================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Colorful command prompt
source ~/.dotfiles/git-prompt.sh
export PS1=' \[\033]0;$MSYSTEM:\w\007 \033[32m\]\u@\h \[\033[33m\w$(__git_ps1 " (%s)")\033[0m\]\n\$ '

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Handy directory navigation
shopt -s autocd

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Generate a gitignore file (http://www.gitignore.io/)
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Read from alias definitions.
if [ -f ~/.dotfiles/bash_aliases ]; then
    . ~/.dotfiles/bash_aliases
fi

# Start tmux automatically
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux
fi
