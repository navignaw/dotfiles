# Colorful command prompt
source ~/.dotfiles/git-prompt.sh
export PS1=' \[\033]0;$MSYSTEM:\w\007 \033[32m\]\u@\h \[\033[33m\w$(__git_ps1 " (%s)")\033[0m\]\n\$ '

# History settings
HISTCONTROL=ignoreboth # don't save dupes or commands that start with space
shopt -s histappend    # append to history, don't overwrite

# Aliases
alias ls='ls --color'
alias ll='ls -l --color'

# Handy directory navigation
shopt -s autocd
alias back='cd $OLDPWD'

# Copy current working directory to clipboard
alias cpwd='pwd | xclip -selection clipboard'

# Source bashrc
alias srcbash='source ~/.bashrc'

# Generate a gitignore file (http://www.gitignore.io/)
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Git aliases
alias gs='git status'
alias gst='git status'
alias ga='git add'
alias gall='git add .'
alias gb='git branch --color'
alias gd='git diff'
alias gds='git diff --stat'
alias gdst='git diff --stat'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gam='git commit -a --amend'
alias gco='git checkout'
alias gl='git pull'
alias glog='git log --color --graph --date=relative'
alias gp='git push'
alias grb='git rebase -i'
