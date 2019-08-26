#!/usr/bin/env bash

BASEDIR=$(pwd)

# Backup existing files, unless they are symlinks
echo -e "Creating backups..."
if [[ ! -d "$BASEDIR/backups" ]]; then
  mkdir "$BASEDIR/backups"
fi

for dotfile in vimrc bashrc gitconfig tmux.conf; do
  if [[ -f "$HOME/.$dotfile" && ! -L "$HOME/.$dotfile" ]]; then
    echo -e "Moving $dotfile to $BASEDIR/backups"
    mv "$HOME/.$dotfile" "$BASEDIR/backups/$dotfile"
  fi

  # Move dotfile to the appropriate location.
  cp "$BASEDIR/$dotfile" "$HOME/.$dotfile"
done

# Additional symlinks
sudo ln -s "$BASEDIR/open.sh" "/usr/bin/open"

if [ $? -eq 0 ]; then
  echo -e "dotfiles successfully installed!"
fi

# Install and update submodules
unset GIT_DIR
git submodule init
git submodule update

if [ $? -eq 0 ]; then
  echo -e "submodules successfully installed!"
fi

# TODO: install font
