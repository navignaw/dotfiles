# Aliases
alias ls='ls --color'
alias ll='ls -l --color'

# Handy directory navigation
shopt autocd
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

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
