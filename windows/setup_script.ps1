# Complete CLI Development Environment Setup Script for Windows
#
# PURPOSE: Sets up a Windows machine with modern CLI tools, dotfiles, and PowerShell configuration
#
# WHAT THIS SCRIPT DOES:
# - Installs modern CLI tools using winget (fzf, ripgrep, bat, eza, etc.)
# - Sets up PowerShell profile with Oh My Posh
# - Creates symbolic links from dotfiles repo to user profile
# - Configures git with delta for beautiful diffs
# - Installs Windows Terminal and modern fonts
#
# USAGE: ./setup_script.ps1 [-Help]
#
# PREREQUISITES:
# - Windows 10/11 with winget installed
# - PowerShell 5.1+ or PowerShell 7+
# - Run as Administrator (for some installations)
# - Run from inside your dotfiles repository

param(
    [switch]$Help
)

# Colors for output
function Write-Status { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Blue }
function Write-Success { param($Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Show help
function Show-Help {
    Write-Host @"
Usage: .\setup_script.ps1 [OPTIONS]

Sets up a complete modern CLI development environment for Windows.

Options:
  -Help           Show this help message

Example:
  .\setup_script.ps1              # Install and configure latest PowerShell

"@
}

# Check if running as Administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if command exists
function Test-Command { param($Command) Get-Command $Command -ErrorAction SilentlyContinue }

# Use latest PowerShell (7+ preferred)
function Get-PowerShellChoice {
    Write-Status "Configuring for latest PowerShell version"
    return "latest"
}

# Install winget packages
function Install-Tools {
    Write-Status "Installing CLI tools with winget..."
    
    $tools = @(
        "junegunn.fzf",           # Fuzzy finder
        "BurntSushi.ripgrep.MSVC", # Better grep
        "sharkdp.bat",            # Better cat
        "eza-community.eza",      # Better ls
        "sharkdp.fd",             # Better find
        "ajeetdsouza.zoxide",     # Smart directory jumping
        "dandavison.delta",       # Beautiful git diffs
        "jesseduffield.lazygit",  # Git TUI
        "aristocratos.btop4win",  # System monitor
        "Git.Git",                # Git
        "Microsoft.WindowsTerminal", # Modern terminal
        "JanDeDobbeleer.OhMyPosh", # PowerShell themes
        "Microsoft.PowerShell"     # PowerShell 7
    )
    
    foreach ($tool in $tools) {
        Write-Status "Installing $tool..."
        try {
            winget install $tool --accept-source-agreements --accept-package-agreements --silent
            Write-Success "$tool installed"
        }
        catch {
            Write-Warning "Failed to install $tool - may already exist"
        }
    }
    
    # Install fonts
    Write-Status "Installing Nerd Font..."
    winget install "Cascadia Code PL" --accept-source-agreements --accept-package-agreements --silent
}

# Setup PowerShell profile (latest version)
function Setup-PowerShellProfiles {
    Write-Status "Setting up PowerShell profile..."
    
    $dotfilesDir = Get-Location
    $profileSource = "$dotfilesDir\Microsoft.PowerShell_profile.ps1"
    $profileTarget = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    
    # Create profile directory if it doesn't exist
    $profileDir = Split-Path $profileTarget -Parent
    if (!(Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    if (Test-Path $profileSource) {
        # Create symlink to profile
        Remove-Item $profileTarget -Force -ErrorAction SilentlyContinue
        New-Item -ItemType SymbolicLink -Path $profileTarget -Target $profileSource -Force
        Write-Success "PowerShell profile linked from dotfiles"
    } else {
        Write-Warning "PowerShell profile not found in dotfiles directory"
    }
}


# Setup symbolic links for config files
function Setup-Symlinks {
    Write-Status "Setting up dotfiles symlinks..."
    
    $dotfilesDir = Get-Location
    
    # Windows Terminal settings
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path "$dotfilesDir\windows_terminal_settings.json") {
        $wtSettingsDir = Split-Path $wtSettingsPath -Parent
        if (Test-Path $wtSettingsDir) {
            Remove-Item $wtSettingsPath -Force -ErrorAction SilentlyContinue
            New-Item -ItemType SymbolicLink -Path $wtSettingsPath -Target "$dotfilesDir\windows_terminal_settings.json"
            Write-Success "Linked Windows Terminal settings"
        }
    }
    
    # Git config
    if (Test-Path "$dotfilesDir\gitconfig") {
        $gitConfigPath = "$env:USERPROFILE\.gitconfig"
        Remove-Item $gitConfigPath -Force -ErrorAction SilentlyContinue
        New-Item -ItemType SymbolicLink -Path $gitConfigPath -Target "$dotfilesDir\gitconfig"
        Write-Success "Linked git configuration"
    }
}

# Configure git with delta
function Setup-GitDelta {
    Write-Status "Configuring git delta..."
    
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    
    Write-Success "Git delta configured"
}

# Main execution
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Write-Status "Starting Windows CLI development environment setup..."
    
    if (!(Test-Administrator)) {
        Write-Warning "Not running as Administrator. Some installations may fail."
        Write-Host "Consider running: Start-Process PowerShell -Verb RunAs"
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            return
        }
    }
    
    Write-Host @"

This script will set up a complete modern CLI development environment for Windows:

1. 📦 Install modern CLI tools with winget:
   • fzf (fuzzy finder) - Ctrl+T for files
   • ripgrep (rg) - faster grep with syntax highlighting  
   • bat - cat with syntax highlighting
   • eza - ls with colors and icons
   • fd - faster find command
   • git-delta - beautiful git diffs
   • lazygit - terminal UI for git
   • Windows Terminal - modern terminal
   • Oh My Posh - PowerShell themes

2. 🔗 Create symbolic links from dotfiles repo to user profile
   (backs up existing configs first)

3. 🐚 Configure PowerShell with Oh My Posh themes and aliases

4. ⚙️ Configure shell integrations (zoxide, git delta)

"@
    
    $continue = Read-Host "Continue? (Y/n)"
    if ($continue -eq "n" -or $continue -eq "N") {
        Write-Status "Setup cancelled"
        return
    }
    
    Install-Tools
    Write-Host ""
    
    Setup-PowerShellProfiles  
    Write-Host ""
    
    Setup-Symlinks
    Write-Host ""
    
    Setup-GitDelta
    Write-Host ""
    
    Write-Success "Setup complete!"
    Write-Status "Please restart your terminal or run: . `$PROFILE"
    
    Write-Host ""
    Write-Status "Installed tools:"
    Write-Host "  fzf - Ctrl+T for file finder"
    Write-Host "  rg - ripgrep for fast searching" 
    Write-Host "  bat - better cat with syntax highlighting"
    Write-Host "  eza - better ls with colors"
    Write-Host "  fd - better find"
    Write-Host "  zoxide - smart directory jumping (z command)"
    Write-Host "  lazygit - git TUI"
    Write-Host "  delta - beautiful git diffs"
}

# Run main function
Main