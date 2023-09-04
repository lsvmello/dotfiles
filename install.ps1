#!/usr/bin/env pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install git oh-my-posh mingw make python3 ripgrep bat --confirm

# Download Oh-My-Posh files
$ohMyPoshFilePath = "$env:USERPROFILE\lsvmello.omp.toml"
((New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/lsvmello/dotfiles/main/windows/powershell_profile.ps1', $PROFILE))
((New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/lsvmello/dotfiles/main/windows/lsvmello.omp.toml', $ohMyPoshFilePath))

# Install Neovim (pre-release)
choco install neovim neovide --pre --confirm

# Add Windows Context Menu for Neovim
New-Item -Path HKEY_CLASSES_ROOT\*\shell -Name Neovide -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovide'
New-ItemProperty - Path HKEY_CLASSES_ROOT\*\shell\Neovide -Name Icon -Value '"C:\Program Files\Neovide\neovide.exe"'
New-Item -Path HKEY_CLASSES_ROOT\*\shell\Neovide\command -Force | Set-ItemProperty -Name '(Default)' -Value '"C:\Program Files\Neovide\neovide.exe" "%1"'

New-Item -Path HKEY_CLASSES_ROOT\Directory\shell -Name Neovide -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovide'
New-ItemProperty - Path HKEY_CLASSES_ROOT\Directory\shell\Neovide -Name Icon -Value '"C:\Program Files\Neovide\neovide.exe"'
New-Item -Path HKEY_CLASSES_ROOT\Directory\shell\Neovide\command -Force | Set-ItemProperty -Name '(Default)' -Value '"C:\Program Files\Neovide\neovide.exe" "%V"'

New-Item -Path HKEY_CLASSES_ROOT\Directory\Background\shell -Name Neovide -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovide'
New-ItemProperty - Path HKEY_CLASSES_ROOT\Directory\Background\shell\Neovide -Name Icon -Value '"C:\Program Files\Neovide\neovide.exe"'
New-Item -Path HKEY_CLASSES_ROOT\Directory\Background\shell\Neovide\command -Force | Set-ItemProperty -Name '(Default)' -Value '"C:\Program Files\Neovide\neovide.exe" "%V"'

# Clone the repository
mkdir ~/personal
git -C ~/personal clone https://github.com/lsvmello/dotfiles.git

# Copy Neovim's configuration
xcopy ~/personal/dotfiles/xdg_config/nvim "$env:USERPROFILE\AppData\Local\nvim" /E /H /I /Y

# Copy VsVim configuration
xcopy ~/personal/dotfiles/windows/_vsvimrc "$env:USERPROFILE\_vsvimrc" /-I /Y
