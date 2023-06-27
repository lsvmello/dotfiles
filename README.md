# My dotfiles

These are my configuration files and scripts to install them.

## Installation on Linux

_Currently I use this only on **WSL Ubuntu 22.04**, so something might not work on other environments._

### How it works

The `install.sh` script install all the dependencies that I use and creates symbolic links for the `xdg_config` folder on the `$HOME\.config` folder.  
It also creates the `personal` and `work` folder where I keep all my git projects and a `build` folder where I keep the programs that I like to 'build from source'.

#### Installation using `git`:

```bash
mkdir ~/personal
git -C ~/personal clone https://github.com/lsvmello/dotfiles.git
chmod +x ~/personal/dotfiles/install.sh
~/personal/dotfiles/install.sh
```

#### Installation using `curl`:

```bash
curl -sS https://raw.githubusercontent.com/lsvmello/dotfiles/master/install.sh | sh
```

#### Configure `fish` as the default shell:

```bash
chsh -s $(which fish)
```

## Installation on Windows

_The installation is done using **PowerShell**. Run `Get-ExecutionPolicy`. If it returns Restricted, then run `Set-ExecutionPolicy Bypass -Scope Process`._

1. Install **Chocolatey**
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```
1. Install dependencies
    ```powershell
    choco install git mingw make jq python3 ripgrep jq --confirm
    ```
1. Install Neovim (pre-release)
    ```powershell
    choco install neovim --pre --confirm
    ```
1. Clone the repository and copy the `xdg_config\nvim` folder to `%USERPROFILE\AppData\Local\`