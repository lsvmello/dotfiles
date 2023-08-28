#!/usr/bin/env pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install git oh-my-posh mingw make jq python3 ripgrep jq bat --confirm

# Download Oh-My-Posh files
$ohMyPoshFilePath = "$env:USERPROFILE\lsvmello.omp.toml"
((New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/lsvmello/dotfiles/main/windows/powershell_profile.ps1', $PROFILE))
((New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/lsvmello/dotfiles/main/windows/lsvmello.omp.toml', $ohMyPoshFilePath))

# Install Neovim (pre-release)
choco install neovim --pre --confirm

# Add Windows Context Menu for Neovim
New-Item -Path HKEY_CLASSES_ROOT\*\shell -Name Neovim -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovim'
New-ItemProperty - Path HKEY_CLASSES_ROOT\*\shell\Neovim -Name Icon -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe'
New-Item -Path HKEY_CLASSES_ROOT\*\shell\Neovim\command -Force | Set-ItemProperty -Name '(Default)' -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe "%1"'

New-Item -Path HKEY_CLASSES_ROOT\Directory\shell -Name Neovim -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovim'
New-ItemProperty - Path HKEY_CLASSES_ROOT\Directory\shell\Neovim -Name Icon -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe'
New-Item -Path HKEY_CLASSES_ROOT\Directory\shell\Neovim\command -Force | Set-ItemProperty -Name '(Default)' -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe "%V"'

New-Item -Path HKEY_CLASSES_ROOT\Directory\Background\shell -Name Neovim -Force | Set-ItemProperty -Name '(Default)' -Value 'Open with Neovim'
New-ItemProperty - Path HKEY_CLASSES_ROOT\Directory\Background\shell\Neovim -Name Icon -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe'
New-Item -Path HKEY_CLASSES_ROOT\Directory\Background\shell\Neovim\command -Force | Set-ItemProperty -Name '(Default)' -Value 'C:\tools\neovim\nvim-win64\bin\nvim-qt.exe "%V"'

# Clone the repository
mkdir ~/personal
git -C ~/personal clone https://github.com/lsvmello/dotfiles.git

# Copy Neovim's configuration
xcopy ~/personal/dotfiles/xdg_config/nvim "$env:USERPROFILE\AppData\Local\nvim" /E /H /I /Y

# Copy VsVim configuration
xcopy ~/personal/dotfiles/windows/_vsvimrc "$env:USERPROFILE\_vsvimrc" /-I /Y
