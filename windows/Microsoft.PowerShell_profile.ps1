# PowerShell Profile Configuration
# Equivalent to .zshrc/.bashrc for PowerShell
# Location: ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1

# Oh My Posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression

# GO STUFF
$env:GO111MODULE = "off"

# GIT SETUP START ===============================
# Git aliases
function gc { param([string]$message) git commit -m $message }
function gs { git status }
function gpl { git pull }
function gph { git push }

# Push to multiple remotes
function gph2 {
    param([string]$branch)
    
    if (-not $branch) {
        Write-Host "Usage: gph2 <branch>"
        return
    }
    
    # Push to GitHub
    git push github $branch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Everything up-to-date github"
    } else {
        Write-Host "Push to github failed"
    }
    
    # Push to GitLab
    git push gitlab $branch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Everything up-to-date gitlab"
    } else {
        Write-Host "Push to gitlab failed"
    }
}

# Create and push to two remotes
function create2repo {
    param([string]$repoName)
    
    if (-not $repoName) {
        Write-Host "Usage: create2repo <repo_name>"
        return
    }
    
    # Initialize repository
    "# $($repoName -replace '\..*$','')" | Out-File -FilePath README.md
    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main
    
    # Add remotes and push
    git remote add github "git@github.com:alexsusanu/$repoName"
    git push -u github main
    
    git remote add gitlab "git@gitlab.com:g5873/$repoName"
    git push --set-upstream gitlab --all
    git push --set-upstream gitlab --tags
}

# Backup function
function backup {
    git add .
    git commit -m "backup $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push
}
# GIT SETUP STOP ===============================

# CLI ALIASES
Set-Alias -Name c -Value Clear-Host
function h { Get-History }
function uu { [System.Guid]::NewGuid().ToString() | Set-Clipboard }
function cp { param($source, $destination) Copy-Item $source $destination -Confirm }
function mv { param($source, $destination) Move-Item $source $destination -Confirm }
function rm { param($path) Remove-Item $path -Confirm }
function view { python -m http.server }
function chrome { param($url) Start-Process "chrome.exe" $url }
function dt { 
    $datetime = (Get-Date).AddHours(-2).ToString("yyyy-MM-ddTHH:mm:ss")
    $datetime | Set-Clipboard
    Write-Host "Copied $datetime to clipboard"
}

# Import fzf if available
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Import-Module PSFzf -ErrorAction SilentlyContinue
}

# Better aliases (using modern CLI tools)
Set-Alias -Name ls -Value eza
function ll { eza -la --icons }
function tree { eza --tree }
Set-Alias -Name cat -Value bat
Set-Alias -Name grep -Value rg
Set-Alias -Name find -Value fd

# fzf options
$env:FZF_DEFAULT_COMMAND = 'fd --type f'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND

# GitHub Copilot aliases
Set-Alias -Name cox -Value "gh copilot explain"
Set-Alias -Name cos -Value "gh copilot suggest"

# Zoxide Integration for PowerShell
# Initialize zoxide for smart directory jumping
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# CLI Help Function for PowerShell
function cli_help {
    param([string]$tool = "")
    
    Write-Host ""
    Write-Host "🚀 CLI Tools Quick Reference" -ForegroundColor Blue
    Write-Host "=============================="
    Write-Host ""
    
    switch ($tool) {
        { $_ -eq "" -or $_ -eq "all" } {
            Write-Host "📋 All Tools Overview:" -ForegroundColor Yellow
            Write-Host "  fzf        - Fuzzy finder (Ctrl+R, Ctrl+T)"
            Write-Host "  grep       - Fast text search (rg -i)"
            Write-Host "  find       - Better file finder (fd)"
            Write-Host "  cat        - Cat with syntax highlighting (bat)"
            Write-Host "  ls/ll      - ls with colors and icons (eza)"
            Write-Host "  tree       - Directory structure (eza --tree)"
            Write-Host "  z          - Smart directory jumping"
            Write-Host "  lazygit    - Git TUI"
            Write-Host ""
            Write-Host "💡 Use: cli_help <tool_name> for specific help" -ForegroundColor Green
        }
        "fzf" {
            Write-Host "🔍 fzf - Fuzzy Finder" -ForegroundColor Yellow
            Write-Host "  fzf                  # Search files in current directory"
            Write-Host "  Ctrl+R               # Fuzzy search command history"
            Write-Host "  Ctrl+T               # Fuzzy find files, paste path"
        }
        { $_ -eq "rg" -or $_ -eq "ripgrep" -or $_ -eq "grep" } {
            Write-Host "🔍 rg/grep - Fast Search" -ForegroundColor Yellow
            Write-Host "  rg 'function'        # Find 'function' in all files"
            Write-Host "  rg 'todo' -i         # Case-insensitive search"
            Write-Host "  rg 'error' --type js # Search only in JavaScript files"
            Write-Host "  rg 'import' -A 3     # Show 3 lines after each match"
        }
        { $_ -eq "fd" -or $_ -eq "find" } {
            Write-Host "📁 fd/find - Better Find" -ForegroundColor Yellow
            Write-Host "  fd config.js         # Find files named 'config.js'"
            Write-Host "  fd -e py             # Find all Python files"
            Write-Host "  fd -t d node_modules # Find directories named 'node_modules'"
        }
        { $_ -eq "bat" -or $_ -eq "cat" } {
            Write-Host "📄 bat/cat - Better Cat" -ForegroundColor Yellow
            Write-Host "  bat script.py        # View Python file with syntax highlighting"
            Write-Host "  bat README.md        # View markdown with formatting"
            Write-Host "  bat -n config.js     # Show with line numbers"
        }
        { $_ -eq "eza" -or $_ -eq "ls" -or $_ -eq "ll" } {
            Write-Host "📂 eza/ls/ll - Better ls" -ForegroundColor Yellow
            Write-Host "  ls                   # List files with colors and icons"
            Write-Host "  ll                   # Long format with permissions, dates, sizes"
            Write-Host "  eza --git            # Show git status"
        }
        { $_ -eq "z" -or $_ -eq "zoxide" } {
            Write-Host "🚀 z (zoxide) - Smart Directory Jumping" -ForegroundColor Yellow
            Write-Host "  z workspace          # Jump to workspace directory"
            Write-Host "  z dotfiles           # Jump to dotfiles directory"
            Write-Host "  zi                   # Interactive directory picker"
        }
        "lazygit" {
            Write-Host "🔧 lazygit - Git TUI" -ForegroundColor Yellow
            Write-Host "  lazygit              # Visual git interface"
            Write-Host "  Space                # Stage/unstage files"
            Write-Host "  c                    # Commit staged changes"
            Write-Host "  P                    # Push to remote"
        }
        default {
            Write-Host "❓ Available tools:" -ForegroundColor Red
            Write-Host "  fzf, grep, find, cat, ls, ll, tree, z, lazygit"
            Write-Host ""
            Write-Host "Usage: cli_help <tool_name>"
            Write-Host "       cli_help all"
        }
    }
    Write-Host ""
}

# Alias for shorter command
Set-Alias -Name ch -Value cli_help

# Diary function for PowerShell
function diary {
    param([string]$entry = "")
    
    $file = "$env:USERPROFILE\diary\$(Get-Date -Format 'yyyy-MM-dd').txt"
    $diaryDir = Split-Path $file -Parent
    
    if (!(Test-Path $diaryDir)) {
        New-Item -ItemType Directory -Path $diaryDir -Force | Out-Null
    }
    
    "=== $(Get-Date -Format 'HH:mm') ===" | Out-File -FilePath $file -Append
    
    if (-not $entry) {
        Write-Host "Enter your diary entry (Ctrl+C to finish):"
        $lines = @()
        while ($true) {
            try {
                $line = Read-Host
                $lines += $line
            }
            catch {
                break
            }
        }
        $lines -join "`n" | Out-File -FilePath $file -Append
    } else {
        $entry | Out-File -FilePath $file -Append
    }
    
    "" | Out-File -FilePath $file -Append
    Write-Host "Entry added to $file"
}

# PowerShell completion enhancements
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Emacs

# fzf key bindings for PowerShell
Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock {
    $result = fzf
    if ($result) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($result)
    }
}

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock {
    $result = Get-History | ForEach-Object { $_.CommandLine } | fzf
    if ($result) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($result)
    }
}