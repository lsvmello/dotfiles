# My dotfiles

These are my configuration files and scripts to install them.

_Currently I use this only on **WSL Ubuntu 22.04**, so something might not work on other environments._

## How it works

The `install.sh` script install all the dependencies that I use and creates symbolic links for the `xdg_config` folder on the `$HOME\.config` folder.  
It also creates the `personal` and `work` folder where I keep all my git projects and a `build` folder where I keep the programs that I like to 'build from source'.

### Installation using `git`:

```bash
mkdir ~/personal && cd ~/personal
git clone https://github.com/lsvmello/dotfiles.git
cd dotfiles
chmod +x install.sh
.\install.sh
```

### Installation using `curl`:

```bash
curl -sS https://raw.githubusercontent.com/lsvmello/dotfiles/master/install.sh | sh
```

### Configure `fish` as the default shell:

```bash
chsh -s $(which fish)
```
