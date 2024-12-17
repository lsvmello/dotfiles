#!/usr/bin/env pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install `
  azure-cli `
  bat `
  curl `
  docker-cli `
  docker-compose `
  docker-engine `
  fzf `
  git `
  jq `
  lazygit `
  make `
  mingw `
  mongodb-shell `
  openssl `
  powertoys `
  python312 `
  ripgrep `
  starship `
  winmerge `
  yq `
  --confirm

# Install Neovim (pre-release)
choco install neovim --pre --confirm

# Clone the repository
mkdir ~/personal
git -C ~/personal clone https://github.com/lsvmello/dotfiles.git

# Copy Neovim's configuration
xcopy ~/personal/dotfiles/xdg_config/nvim "$env:USERPROFILE\AppData\Local\nvim" /E /H /I /Y

# Copy other configuration files
xcopy ~/personal/dotfiles/xdg_config/startship.toml "$env:USERPROFILE\.config" /-I /Y
xcopy ~/personal/dotfiles/xdg_config/.fzf "$env:USERPROFILE\.config" /-I /Y
xcopy ~/personal/dotfiles/windows/_vsvimrc "$env:USERPROFILE\_vsvimrc" /-I /Y
xcopy ~/personal/dotfiles/main/windows/powershell_profile.ps1 $env:PROFILE /-I /Y
