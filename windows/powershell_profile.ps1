# ENVIRONMENT VARIABLES
$env:EDITOR="nvim"
$env:FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
$env:FZF_DEFAULT_OPTS_FILE="${HOME}\.config\.fzf"

# TERMINAL INTEGRATIONS
# Set CWD - https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
function Invoke-Starship-PreCommand {
  $loc = $executionContext.SessionState.Path.CurrentLocation;
  $prompt = "$([char]27)]9;12$([char]7)"
  if ($loc.Provider.Name -eq "FileSystem")
  {
    $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  $host.ui.Write($prompt)
}

# stash away the prompt() that starship sets
$Global:__OriginalPrompt = $function:Prompt

function Global:__Terminal-Get-LastExitCode {
  if ($? -eq $True) { return 0 }
  $LastHistoryEntry = $(Get-History -Count 1)
  $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
  if ($IsPowerShellError) { return -1 }
  return $LastExitCode
}

function prompt {
  $gle = $(__Terminal-Get-LastExitCode);
  $LastHistoryEntry = $(Get-History -Count 1)
  if ($Global:__LastHistoryId -ne -1) {
    if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
      $out += "`e]133;D`a"
    } else {
      $out += "`e]133;D;$gle`a"
    }
  }
  $loc = $($executionContext.SessionState.Path.CurrentLocation);
  $out += "`e]133;A$([char]07)";
  $out += "`e]9;9;`"$loc`"$([char]07)";
  
  $out += $Global:__OriginalPrompt.Invoke(); # <-- This line adds the original prompt back

  $out += "`e]133;B$([char]07)";
  $Global:__LastHistoryId = $LastHistoryEntry.Id
  return $out
}

# FUNCTIONS
function .. { Set-Location .\.. }
function ... { Set-Location .\..\.. }

function work {
  $options = @()
    $slnFile = Get-ChildItem -Path . -Recurse -Filter *.sln -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($slnFile) {
      $options += @{ Name = "Visual Studio ($($slnFile.Name))"; Command = { start $slnFile.FullName } }
    }

  $ideaFolder = Get-ChildItem -Path . -Directory -Filter .idea -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($ideaFolder) {
      $options += @{ Name = "IntelliJ IDEA"; Command = { idea64 . } }
    }

  $vsFolder = Get-ChildItem -Path . -Directory -Filter .vscode -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($vsFolder) {
      $options += @{ Name = "Visual Studio Code"; Command = { code . } }
    }

  if ($options.Count -eq 1) {
    Write-Host "Starting $($options[0].Name)"
    & $options[0].Command
    return
  }

  Write-Host "Choose the editor:"
    for ($i = 0; $i -lt $options.Count; $i++) {
      Write-Host "$($i + 1). $($options[$i].Name)"
    }

  $choice = Read-Host "Enter your choice (1-$($options.Count))"
    $choice = [int]$choice - 1

    if ($choice -ge 0 -and $choice -lt $options.Count) {
      & $options[$choice].Command
    } else {
      Write-Host "Invalid choice"
    }
}

function fp {
  param (
    [Alias("v", "vert")]
    [switch]$vertical,
    [Alias("h", "split")]
    [switch]$horizontal,
    [Alias("t")]
    [switch]$tab,
    [Alias("e")]
    [switch]$explorer
  )

  $projectsDir = "$HOME\git"
  # Use ripgrep to find all directories in the base directory (non-recursive)
  $selected = Get-ChildItem $projectsDir -Directory
               | foreach { $_.Name }
               | fzf --height=40%

  if ($selected) {
    $selectedDir = "${projectsDir}\${selected}"
    if ($vertical) {
      wt --window 0 split-pane --vertical -d $selectedDir
    } elseif ($horizontal) {
      wt --window 0 split-pane --horizontal -d $selectedDir
    } elseif ($tab) {
      wt --window 0 new-tab -d $selectedDir
    } elseif ($explorer) {
      explorer $selectedDir
    } else {
        Set-Location -LiteralPath $selectedDir
    }
  }
}

function fg {
    param (
        [string]$Query = '',
        [string]$Path  = '.'
    )

    $rgCommand = "rg --column --line-number --no-heading --color=always --smart-case"

    fzf --ansi --disabled --query "$query" `
        --bind "start:reload:$rgCommand {q}" `
        --bind "change:reload:$rgCommand {q} || rem" `
        --delimiter ":" `
        --height=70% `
        --preview "bat --color=always {1} --highlight-line {2} --plain" `
        --preview-window "right,60%,border-vertical,+{2}+3/3,hidden" `
        --bind "enter:become(nvim {1} +{2})"
}

# ALIASES
Set-Alias -Name c -Value cls
Set-Alias -Name e -Value explorer
Set-Alias -Name g -Value git
Set-Alias -Name lg -Value lazygit
Set-Alias -Name v -Value nvim

# INIT
Import-Module -Name Terminal-Icons
Invoke-Expression (&starship init powershell)
