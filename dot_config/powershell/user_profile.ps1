# Loaded from $PROFILE (see .chezmoiscripts/run_once_after_30-powershell-profile.ps1.tmpl)

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History

# Aliases
Set-Alias -Name g -Value git
Set-Alias -Name c -Value claude
Set-Alias -Name pn -Value pnpm
Set-Alias -Name cz -Value chezmoi
Set-Alias -Name vim -Value nvim
function claude-yolo { claude --dangerously-skip-permissions @args }

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue
    function ls { eza @args }
    function ll { eza -l -g --icons=auto @args }
    function lla { eza -l -g -a --icons=auto @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
    function bat { bat.exe --theme "Solarized (light)" @args }
}

# Copy the current directory to the clipboard, with $HOME as ~
function cpwd {
    $PWD.Path.Replace($HOME, "~") | Set-Clipboard
}

function which($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

$localProfile = Join-Path $PSScriptRoot "user_profile.local.ps1"
if (Test-Path $localProfile) { . $localProfile }
