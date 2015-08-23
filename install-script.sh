#!/usr/bin/env bash

PWD=$(pwd)

# Backup existing files, unless they are symlinks
echo -e "Creating backups..."
mkdir "$PWD/backups"

if [[ -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
  mv ~/.vimrc "$PWD/backups/vimrc"
fi

if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]]; then
  mv ~/.bashrc "$PWD/backups/bashrc"
fi

# Create symlinks to appropriate files
ln -s "$PWD/vimrc" ~/.vimrc
ln -s "$PWD/bashrc" ~/.bashrc

echo -e "vimrc and bashrc successfully installed!"

# Install and update submodules
unset GIT_DIR
git submodule init
git submodule update
echo -e "submodules successfully installed!"

# TODO: install font
