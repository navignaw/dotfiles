#!/usr/bin/env bash

BASEDIR=$(pwd)

# Backup existing files, unless they are symlinks
echo -e "Creating backups..."
if [[ ! -d "$BASEDIR/backups" ]]; then
  mkdir "$BASEDIR/backups"
fi

for dotfile in vimrc zshrc gitconfig tmux.conf agignore; do
  if [[ -f "$HOME/.$dotfile" && ! -L "$HOME/.$dotfile" ]]; then
    echo -e "Moving $dotfile to $BASEDIR/backups"
    mv "$HOME/.$dotfile" "$BASEDIR/backups/$dotfile"
  fi

  # Move dotfile to the appropriate location.
  cp "$BASEDIR/$dotfile" "$HOME/.$dotfile"
done

cp "$BASEDIR/lambda-mod.zsh-theme" "$HOME/.oh-my-zsh/themes"

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

echo -e "Installing spotify-now"
sudo cp $BASEDIR/lib/spotify-now/spotify-now /usr/bin

echo -e "Installing gcalcli"
cd "$BASEDIR/lib/gcalcli" && sudo python setup.py install

echo -e "Installing powerline font"
sudo apt-get install fonts-powerline

echo -e "Installing YouCompleteMe"
sudo apt install build-essential cmake python3-dev
cd "$BASEDIR/vim/bundle/YouCompleteMe" && python3 install.py
