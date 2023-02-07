#!/bin/bash

set -e # exit immediately if a command exits with a non-zero status.
set -x # print commands and their arguments as they are executed.

mkdir -p ~/build # build from source projects
mkdir -p ~/git   # personal projects

# pulls the latest version of the directory (arg1)
# or clones the repository (arg2) into the directory (arg1)
function pull_or_clone {
  if [[ -d $1 ]]; then
    git -C $1 pull
  else
    git clone $2 $1
  fi
}

# updates the distro
sudo apt update
sudo apt -y upgrade

# install tools
sudo apt install -y \
  fish tmux \
  git curl \
  fzf jq \
  python3-pip python3.8-venv

# install nodejs and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# get the latest neovim's source code
pull_or_clone ~/build/neovim https://github.com/neovim/neovim

# install neovim's dependencies
sudo apt install -y \
  ninja-build gettext \
  libtool libtool-bin \
  autoconf automake cmake \
  g++ pkg-config unzip doxygen

# install neovim
pushd ~/build/neovim
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
popd 

if ! command -v cargo &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -y
fi

# install rust tools
cargo install \
  stylua \
  ripgrep \
  starship \
  hyperfine \
  tree-sitter-cli

# install python tools
pip install \
  pre-commit

# get the latest dotfiles
pull_or_clone ~/git/dotfiles https://github.com/lsvmello/dotfiles 

# if folder already exists then create a backup
if [[ -d ~/.config ]]; then
  TEMP_CONFIG_DIR=_config_temp
  mv ~/.config $TEMP_CONFIG_DIR
fi
  
# link the .config directory
ln -sv ~/git/dotfiles/xdg_config/ ~/.config
  
# restores and deletes the backup
# if the files are different the changes
# will show up on the `git status`
if [[ $TEMP_CONFIG_DIR ]]; then
  cp -r $TEMP_CONFIG_DIR /.config
  rm -rf $TEMP_CONFIG_DIR
fi

# install neovim's plugins
nvim --headless "+Lazy! sync" +qa

# removing unnecessary package
sudo apt autoremove -y
