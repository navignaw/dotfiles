# Uncomment to profile zsh
#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

eval "$(dircolors ~/.dotfiles/dircolors)"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit this file.
[[ ! -f ~/.config/p10k/p10k.zsh ]] || source ~/.config/p10k/p10k.zsh

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(bazel git fzf fzf-tab git-open-pr globalias docker docker-compose kubectl web-search yarn zsh-autosuggestions zsh-syntax-highlighting zoxide)

ZSH_WEB_SEARCH_ENGINES=(
  so "https://stackoverflow.com/search?q="
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Start tmux automatically
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux new-session -A -s main
fi

# # Auto-add SSH agent
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#     eval "$(ssh-agent -s)"
#     ssh-add ~/.ssh/id_rsa
# fi

# zsh-autosuggestions
#bindkey '^I'   complete-word      # tab         | autosuggest
bindkey '^[[Z' autosuggest-accept # shift + tab | complete

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40%'
export FZF_PREVIEW_PREVIEW_BAT_THEME='OneHalfDark'

_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --follow --exclude .git . "$1"
}

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Use tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# autocomplete
fpath+=~/.zfunc
autoload -Uz compinit && compinit

#zprof
