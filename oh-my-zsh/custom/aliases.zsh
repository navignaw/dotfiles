# Aliases

# Copy current working directory to clipboard
alias cpwd='pwd | xclip -selection clipboard'

# Source dotfiles
alias srczsh='source ~/.zshrc'
alias srctmux='tmux source-file ~/.config/tmux/tmux.conf'
alias svenv='source .venv/bin/activate'

# Zoxide and eza
alias cd="z"
alias ll="eza --color=always --long --git --icons=always"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# Git aliases
alias gs='git switch'
alias gst='git status'
alias ga='git add'
alias gall='git add .'
alias gb='git branch --color'
alias gbd='git branch -D'
alias gd='git diff'
alias gds='git diff --stat'
alias gdst='git diff --stat'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gam='git commit --amend'
alias gama='git commit -a --amend'
alias gco='git checkout'
alias gl='git pull --prune'
alias glog="git log --color --graph --date=relative --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp='git push origin HEAD'
alias grb='git rebase -i'
alias grbo='git rebase-onto'
alias dev='git checkout develop'
alias up='revup upload'

# Python default
alias python=python3
alias pip=pip3

# Neovim
alias v='nvim --listen $NVIM_SERVER_FILE'
alias vim='nvim --listen $NVIM_SERVER_FILE'

# Docker
alias dex='docker exec -it'
alias dlog='docker logs'
alias dcb='docker-compose build'
alias dcu='docker-compose up'

alias k=kubectl

# Don't expand these aliases automatically
GLOBALIAS_FILTER_VALUES=( ls ll glog v )
