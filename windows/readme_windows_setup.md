# Windows CLI Development Environment Setup

## 🚀 Quick Start (Coming from Linux)

**New Windows machine or setting up for the first time?**

1. **Open PowerShell as Administrator** (Right-click PowerShell → "Run as Administrator")
2. **Clone this repository** to your machine
3. **Run the setup script:**
   ```powershell
   cd C:\path\to\your\dotfiles
   .\setup_script.ps1
   ```
4. **Restart PowerShell** - you're done!

## Windows vs Linux Differences (Linux User Guide)

### **Package Management**
| Linux | Windows |
|-------|---------|
| `apt install` / `yum install` | `winget install` |
| `/usr/bin/` | `C:\Program Files\` |
| `~/.bashrc` / `~/.zshrc` | `$PROFILE` |

### **File System**
| Linux | Windows | 
|-------|---------|
| `/home/username/` | `C:\Users\Username\` |
| `~/.config/` | `$env:APPDATA` or `$env:LOCALAPPDATA` |
| `/etc/` | `C:\Windows\System32\` |
| `chmod +x` | Not needed (executables are .exe/.ps1) |

### **PowerShell vs Bash**
| Bash/Zsh | PowerShell |
|-----------|------------|
| `ls -la` | `Get-ChildItem` or `ls` (aliased to eza) |
| `cat file.txt` | `Get-Content file.txt` or `cat` (aliased to bat) |
| `grep pattern` | `Select-String` or `grep` (aliased to rg) |
| `ps aux` | `Get-Process` |
| `kill -9 pid` | `Stop-Process -Id pid -Force` |
| `export VAR=value` | `$env:VAR = "value"` |

## PowerShell Profile System (Windows "Dotfiles")

### **Profile Locations**
Unlike Linux where you have `~/.bashrc`, PowerShell profiles are located at:

```powershell
# Check your profile location
$PROFILE

# Common locations:
# PowerShell 7+: ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
# Windows PowerShell 5.1: ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
```

### **Profile Types**
PowerShell has multiple profile types (unlike Linux's single .bashrc):

| Profile Type | Scope | Location |
|--------------|-------|----------|
| `$PROFILE.CurrentUserCurrentHost` | Current user, PowerShell only | Most common |
| `$PROFILE.CurrentUserAllHosts` | Current user, all shells | Recommended for dotfiles |
| `$PROFILE.AllUsersCurrentHost` | All users, PowerShell only | Requires admin |
| `$PROFILE.AllUsersAllHosts` | All users, all shells | System-wide |

**For dotfiles, use:** `$PROFILE.CurrentUserAllHosts`

### **PowerShell Execution Policy**
Windows has execution policies (Linux doesn't). You might need:

```powershell
# Check current policy
Get-ExecutionPolicy

# If restricted, allow scripts (as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Windows Terminal vs Linux Terminal

### **Windows Terminal (Modern)**
- **Install:** `winget install Microsoft.WindowsTerminal`
- **Config location:** `$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
- **Like:** GNOME Terminal, Konsole, but more advanced

### **Legacy Terminals (Avoid)**
- **Command Prompt (cmd.exe)** - old, limited (like `/bin/sh`)
- **Windows PowerShell ISE** - deprecated

### **Terminal Features**
| Linux Terminal | Windows Terminal |
|----------------|------------------|
| Tabs | Tabs ✅ |
| Split panes | Split panes ✅ |
| Copy/paste | Ctrl+Shift+C/V or right-click |
| Font ligatures | Nerd Fonts work ✅ |

## CLI Tools: Linux vs Windows Equivalents

### **Core Tools Installed by Setup Script**
| Linux Tool | Windows Tool | Notes |
|------------|--------------|-------|
| `fzf` | `fzf` | Same tool, works great |
| `ripgrep` | `rg.exe` | Same tool |
| `bat` | `bat.exe` | Same tool |
| `exa`/`eza` | `eza.exe` | Same tool |
| `fd` | `fd.exe` | Same tool |
| `git` | `git.exe` | Same tool |
| `vim` | Available but consider `code` (VS Code) |
| `tmux` | Not available, use Windows Terminal splits |

### **Windows-Specific Additions**
- **Oh My Posh** (instead of Oh My Zsh/Bash)
- **Windows Terminal** (modern terminal emulator)
- **PowerShell 7+** (cross-platform shell)
- **Cascadia Code PL** (Microsoft's programming font with ligatures)

## File Permissions & Security

### **No chmod/sudo equivalent**
```powershell
# Linux: chmod +x script.sh
# Windows: Files are executable by extension (.exe, .ps1, .bat)

# Linux: sudo command
# Windows: Run PowerShell as Administrator
```

### **User Account Control (UAC)**
- Similar to `sudo` prompts
- Some installations require Administrator privileges
- Setup script will warn if not running as admin

## Environment Variables

### **Setting Environment Variables**
| Linux | PowerShell |
|-------|------------|
| `export PATH=$PATH:/new/path` | `$env:PATH += ";C:\new\path"` |
| `export VAR=value` | `$env:VAR = "value"` |
| `echo $HOME` | `$env:USERPROFILE` or `$env:HOME` |
| `echo $USER` | `$env:USERNAME` |

### **Persistent Environment Variables**
```powershell
# Temporary (current session only)
$env:MY_VAR = "value"

# Permanent (like adding to ~/.bashrc)
[System.Environment]::SetEnvironmentVariable("MY_VAR", "value", "User")
```

## Common File Paths

### **Windows Paths (PowerShell understands both)**
| Linux Path | Windows Path | PowerShell Variables |
|------------|--------------|---------------------|
| `~` | `C:\Users\Username` | `$env:USERPROFILE` or `~` |
| `~/Desktop` | `C:\Users\Username\Desktop` | `$env:USERPROFILE\Desktop` |
| `~/.config` | `C:\Users\Username\AppData\Local` | `$env:LOCALAPPDATA` |
| `/tmp` | `C:\Users\Username\AppData\Local\Temp` | `$env:TEMP` |
| `/etc` | `C:\Windows\System32` | `$env:SystemRoot\System32` |

### **Path Separators**
```powershell
# Linux: /path/to/file
# Windows: C:\path\to\file or C:/path/to/file (both work in PowerShell)

# In PowerShell, use Join-Path for cross-platform compatibility
$path = Join-Path $env:USERPROFILE "Documents"
```

## PowerShell vs Bash Scripting

### **Basic Syntax Differences**
| Bash | PowerShell |
|------|------------|
| `#!/bin/bash` | `# PowerShell script` |
| `if [ -f "$file" ]` | `if (Test-Path $file)` |
| `$?` (exit code) | `$LASTEXITCODE` |
| `$1 $2` (args) | `$args[0] $args[1]` or `param()` |
| `$(command)` | `$(command)` ✅ same |
| `command > file` | `command > file` ✅ same |

### **PowerShell Advantages**
- **Object-oriented** - commands return .NET objects, not text
- **Consistent syntax** - `Get-*`, `Set-*`, `New-*` pattern
- **Built-in help** - `Get-Help command -Examples`
- **Tab completion** - much more advanced than bash

## What the Setup Script Does

1. **📦 Installs winget packages** (like `apt install` but for Windows)
   - Modern CLI tools (fzf, ripgrep, bat, eza, etc.)
   - PowerShell 7+ (if not installed)
   - Windows Terminal
   - Git and development tools

2. **🔗 Creates symbolic links** (like Linux dotfiles)
   - Links `Microsoft.PowerShell_profile.ps1` from your repo to `$PROFILE`
   - Links git configuration and other dotfiles

3. **🐚 Configures PowerShell**
   - Installs Oh My Posh (PowerShell equivalent of Oh My Zsh)
   - Sets up same aliases and functions as your Linux setup
   - Configures modern completion and key bindings

4. **⚙️ Shell integrations**
   - Zoxide for smart directory jumping (`z` command)
   - Git delta for beautiful diffs
   - fzf for fuzzy finding (Ctrl+R, Ctrl+T)

## After Setup

### **Verify Installation**
```powershell
# Check PowerShell version (should be 7+)
$PSVersionTable

# Check profile is loaded
Test-Path $PROFILE

# Check tools are available
fzf --version
rg --version
bat --version
eza --version
```

### **Daily Usage**
```powershell
# Your familiar Linux aliases now work:
ls                    # Lists files with colors (eza)
ll                    # Long format listing  
cat file.txt          # Shows file with syntax highlighting (bat)
grep "pattern" *      # Searches files (ripgrep)
find . -name "*.js"   # Finds files (fd)
z workspace           # Smart directory jumping

# Git aliases work the same:
gs                    # git status
gc "commit message"   # git commit -m
gpl                   # git pull
gph                   # git push
backup                # git add . && commit && push

# Help system:
ch                    # Shows CLI tool help
ch fzf                # Shows fzf-specific help
```

### **PowerShell-Specific Features**
```powershell
# Object-oriented output
Get-Process | Where-Object CPU -GT 100 | Sort-Object CPU -Descending

# Built-in cmdlets
Get-ChildItem *.txt | Measure-Object -Property Length -Sum
Get-Content log.txt | Select-String "ERROR" | Group-Object

# .NET integration  
[System.DateTime]::Now.AddDays(-7)  # Date 7 days ago
```

## Troubleshooting

### **Common Issues**

#### "Execution Policy" Error
```powershell
# Run as Administrator:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### "winget not found"
- Install from Microsoft Store: "App Installer"
- Or download from GitHub: microsoft/winget-cli

#### Profile not loading
```powershell
# Check if profile exists
Test-Path $PROFILE

# Check for syntax errors
powershell -NoProfile -Command "& '$PROFILE'"

# Reload profile manually
. $PROFILE
```

#### Oh My Posh not working
```powershell
# Install manually if setup failed
winget install JanDeDobbeleer.OhMyPosh

# Check themes are available
Get-ChildItem $env:POSH_THEMES_PATH
```

## Additional Windows-Specific Tips

### **Package Management**
```powershell
# Search for packages
winget search git

# Install packages
winget install Git.Git

# Upgrade all packages
winget upgrade --all

# Alternative: Chocolatey (like apt)
# Install: https://chocolatey.org/install
# choco install git nodejs python
```

### **Windows Subsystem for Linux (WSL)**
If you prefer Linux environment:
```powershell
# Install WSL (Ubuntu)
wsl --install

# Your Linux dotfiles work unchanged in WSL
# Access Windows files: /mnt/c/Users/Username/
# Access WSL from Windows: \\wsl$\Ubuntu\home\username\
```

This setup gives you a Linux-like CLI experience on Windows while embracing Windows-native tools and conventions!