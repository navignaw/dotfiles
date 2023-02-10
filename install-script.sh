#!/usr/bin/env bash

BASEDIR=$(pwd)

# Backup existing files, unless they are symlinks
echo -e "Creating backups..."
if [[ ! -d "$BASEDIR/backups" ]]; then
  mkdir "$BASEDIR/backups"
fi

for dotfile in vimrc zshrc ripgreprc gitconfig tmux.conf; do
  if [[ -f "$HOME/.$dotfile" && ! -L "$HOME/.$dotfile" ]]; then
    echo -e "Moving $dotfile to $BASEDIR/backups"
    mv "$HOME/.$dotfile" "$BASEDIR/backups/$dotfile"
  fi

  # Move dotfile to the appropriate location.
  cp "$BASEDIR/$dotfile" "$HOME/.$dotfile"
done

echo -e "Installing zsh and oh-my-zsh"
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

echo -e "Installing ripgrep"
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
sudo dpkg -i ripgrep_11.0.2_amd64.deb

echo -e "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

echo -e "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
