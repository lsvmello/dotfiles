#!/bin/bash

set -e # exit immediately if a command exits with a non-zero status.
set -x # print commands and their arguments as they are executed.

mkdir -p ~/build # build from source projects
mkdir -p ~/git   # personal projects

# pulls the latest version of the directory (arg1)
# or clones the repository (arg2) into the directory (arg1)
function pull_or_clone {
  if [[ -d $1 ]]; then
    git -C $1 pull --autostash
  else
    git clone --depth 1 $2 $1
  fi
}

# updates the distro
sudo apt update
sudo apt -y upgrade

# update apt source list
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# install tools
sudo apt install -y \
  fish tmux git \
  curl jq nodejs \
  python3-pip python3.8-venv \

# install rust
if ! command -v cargo &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -y
fi;

# install golang
if ! command -v go &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSfL https://go.dev/dl/go1.20.2.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -
fi;

# install fzf from source
pull_or_clone ~/build/fzf https://github.com/junegunn/fzf.git

sudo ~/build/fzf/install --key-bindings --no-bash --no-zsh --no-completion --update-rc

# install neovim's dependencies
sudo apt install -y \
  ninja-build gettext \
  libtool libtool-bin \
  autoconf automake cmake \
  g++ pkg-config unzip doxygen

# install neovim
pull_or_clone ~/build/neovim https://github.com/neovim/neovim

pushd ~/build/neovim
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
popd 

# install zk
pull_or_clone ~/build/zk https://github.com/mickael-menu/zk

pushd ~/build/zk
make install
popd

# install rust tools
cargo install \
  bat stylua ripgrep \
  starship hyperfine \
  tree-sitter-cli

# install python tools
pip install \
  pre-commit

# get the latest dotfiles
pull_or_clone ~/git/dotfiles https://github.com/lsvmello/dotfiles 

# get the latest zettelkasten
pull_or_clone ~/git/zettelkasten https://github.com/lsvmello/zettelkasten

# initialize the notebook
pushd ~/git/zettelkasten
if [[ -d ~/git/zettelkasten/.zk ]]; then
  zk index --verbose
else
  zk init --no-input
fi
popd

# if folder already exists then create a backup
if [[ -d ~/.config ]]; then
  TEMP_CONFIG_DIR=_config_temp
  mv ~/.config/* $TEMP_CONFIG_DIR
fi
  
# link the .config directory
ln -sv ~/git/dotfiles/xdg_config/ ~/.config
  
# restores and deletes the backup
# if the files are different the changes
# will show up on the `git status`
if [[ $TEMP_CONFIG_DIR ]]; then
  cp -r $TEMP_CONFIG_DIR/* ~/.config
  rm -rf $TEMP_CONFIG_DIR
fi

# install neovim's plugins
nvim --headless "+Lazy! sync" +qa

# removing unnecessary package
sudo apt autoremove -y
