#!/bin/bash

set -e # exit immediately if a command exits with a non-zero status.
set -x # print commands and their arguments as they are executed.

mkdir -p ~/build    # build from source projects
mkdir -p ~/personal # personal projects
mkdir -p ~/work     # work projects

# pulls the latest version of the directory (arg1)
# or clones the repository (arg2) into the directory (arg1)
function pull_or_clone {
  if [[ -d $1 ]]; then
    git -C $1 pull --autostash
  else
    git clone --depth 1 $2 $1
  fi
}

# add apt-repositories
sudo add-apt-repository --yes ppa:fish-shell/release-3

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

# install fzf from source
pull_or_clone ~/build/fzf https://personalhub.com/junegunn/fzf.git
~/build/fzf/install --key-bindings --no-bash --no-zsh --no-completion --update-rc

# install neovim's dependencies
sudo apt install -y \
  ninja-build gettext \
  libtool libtool-bin \
  autoconf automake cmake \
  g++ pkg-config unzip doxygen

# install neovim
pull_or_clone ~/build/neovim https://personalhub.com/neovim/neovim

pushd ~/build/neovim
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
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
pull_or_clone ~/personal/dotfiles https://github.com/lsvmello/dotfiles 

# get the latest zettelkasten
pull_or_clone ~/personal/zettelkasten https://github.com/lsvmello/zettelkasten

# if folder already exists then create a backup
if [[ -d ~/.config ]]; then
  TEMP_CONFIG_DIR=~/_temp_config
  mkdir $TEMP_CONFIG_DIR
  mv ~/.config/* $TEMP_CONFIG_DIR
  rm -rf ~/.config
fi
  
# link the .config directory
ln -sv ~/personal/dotfiles/xdg_config ~/.config
  
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
