#!/usr/bin/env bash

BASEDIR=$(pwd)

echo -e "Installing libraries via Brew package manager"
brew bundle install --file="$BASEDIR/Brewfile"

# check if already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
	echo -e "oh-my-zsh already installed"
else
	echo -e "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Create symlinks for dotfiles and scripts
stow --dotfiles -v --target "$HOME" zsh
stow --dotfiles -v --target "$HOME/.config" .config
stow --dotfiles -v --target "$HOME/.oh-my-zsh/custom" oh-my-zsh/custom
stow -v --target "/usr/local/bin" bin

if [ $? -eq 0 ]; then
	echo -e "dotfiles successfully installed!"
fi

#echo -e "Installing spotify-now"
#sudo cp $BASEDIR/lib/spotify-now/spotify-now /usr/bin

#echo -e "Installing gcalcli"
#cd "$BASEDIR/lib/gcalcli" && sudo python setup.py install
