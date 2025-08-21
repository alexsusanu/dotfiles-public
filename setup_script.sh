#!/bin/bash

# Complete CLI Development Environment Setup Script
#
# PURPOSE: Sets up a new Mac/laptop with all CLI tools, dotfiles, and configurations
#
# WHAT THIS SCRIPT DOES:
# - Installs Homebrew package manager (if not present)
# - Installs modern CLI tools (fzf, ripgrep, bat, eza, etc.) to replace basic Unix tools
# - Creates symbolic links from this dotfiles repo to home directory (~/.zshrc, ~/.tmux.conf, etc.)
# - Installs Oh My Zsh for better shell experience
# - Configures git with delta for beautiful diffs
# - Sets up automated hourly backup of dotfiles to git
# - Installs Alacritty terminal emulator and FiraCode Nerd Font
#
# WHEN TO USE: Run this on a fresh Mac or when setting up development environment
# WHERE TO RUN: From inside your dotfiles repository directory
#
# PREREQUISITES:
# - This script should be inside your dotfiles git repository
# - Your dotfiles (zshrc, tmux.conf, gitconfig, etc.) should be in the same directory
# - You should have git already configured with your credentials

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default shell choice (can be overridden with --shell argument)
SHELL_CHOICE=""

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --shell)
                SHELL_CHOICE="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown argument: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Validate shell choice
    if [[ -n "$SHELL_CHOICE" && "$SHELL_CHOICE" != "zsh" && "$SHELL_CHOICE" != "bash" && "$SHELL_CHOICE" != "both" ]]; then
        print_error "Invalid shell choice: $SHELL_CHOICE. Must be 'zsh', 'bash', or 'both'"
        exit 1
    fi

    # Auto-detect if not specified
    if [[ -z "$SHELL_CHOICE" ]]; then
        if [[ "$SHELL" == */zsh ]]; then
            SHELL_CHOICE="zsh"
            print_status "Auto-detected zsh as default shell"
        elif [[ "$SHELL" == */bash ]]; then
            SHELL_CHOICE="bash"
            print_status "Auto-detected bash as default shell"
        else
            SHELL_CHOICE="both"
            print_status "Unknown default shell, installing both frameworks"
        fi
    fi
}

# Show help message
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Sets up a complete modern CLI development environment with shell frameworks.

Options:
  --shell SHELL    Choose shell framework to install:
                   zsh   - Install Oh My Zsh only
                   bash  - Install Oh My Bash only  
                   both  - Install both frameworks
                   (auto-detects from \$SHELL if not specified)
  
  --help, -h       Show this help message

Examples:
  $0                    # Auto-detect shell and install appropriate framework
  $0 --shell zsh        # Install Oh My Zsh only
  $0 --shell bash       # Install Oh My Bash only
  $0 --shell both       # Install both frameworks

EOF
}

# Install Homebrew Package Manager
# Homebrew is like apt/yum for macOS - lets you install CLI tools easily
# Only installs if not already present
install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew already installed"
        return 0
    fi

    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

# Install Modern CLI Tools
# These tools replace/enhance basic Unix commands with better alternatives:
# - fzf: fuzzy finder for files/history (Ctrl+R, Ctrl+T)
# - ripgrep: faster grep with better output
# - bat: cat with syntax highlighting
# - eza: ls with colors and git status
# - fd: faster, more user-friendly find
# - git-delta: beautiful git diffs with syntax highlighting
# - lazygit: terminal UI for git operations
# - btop: beautiful system monitor (better than htop)
install_cli_tools() {
    print_status "Installing CLI tools..."

    local tools=(
        "fzf"           # Fuzzy finder
        "ripgrep"       # Better grep
        "bat"           # Better cat
        "eza"           # Better ls (maintained fork of exa)
        "fd"            # Better find
        "zoxide"        # Smart directory jumping
        "git-delta"     # Beautiful git diffs
        "dust"          # Better du
        "lazygit"       # Git TUI
        "btop"          # Better htop
        "ncdu"          # Disk usage analyzer
        "tree"          # Directory structure
        "git"           # Git (ensure latest version)
        "vim"           # Vim with better features
        "tmux"          # Terminal multiplexer (optional - consider skipping if using alacritty fullscreen)
        "alacritty"     # Terminal emulator
        "jq"            # JSON processor
    )

    for tool in "${tools[@]}"; do
        if brew list "$tool" &>/dev/null; then
            print_success "$tool already installed"
        else
            print_status "Installing $tool..."
            if [[ "$tool" == "alacritty" ]]; then
                brew install --cask "$tool"
            else
                brew install "$tool"
            fi
            print_success "$tool installed"
        fi
    done

    # Install fzf key bindings
    if command_exists fzf; then
        print_status "Setting up fzf key bindings..."
        case "$SHELL_CHOICE" in
            "zsh")
                $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
                ;;
            "bash")
                $(brew --prefix)/opt/fzf/install --all --no-zsh --no-fish  
                ;;
            "both")
                $(brew --prefix)/opt/fzf/install --all --no-fish
                ;;
        esac
    fi

    # Install Nerd Font for icons
    print_status "Installing Nerd Font for terminal icons..."
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code-nerd-font
    print_success "Nerd Font installed"
}

# Verify Dotfiles Directory
# Confirms that we're running from inside the dotfiles repository
# This script should be run from the same directory that contains your config files
verify_dotfiles() {
    print_status "Using dotfiles from $DOTFILES_DIR"

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi

    print_success "Dotfiles directory verified"
}

# Setup Configuration Symlinks
# Creates symbolic links from your dotfiles repo to their expected locations in home directory
# Example: links ./zshrc to ~/.zshrc so when you edit one, both change
# Backs up existing files to avoid losing your current configs
# This allows you to manage all configs in git while keeping them in standard locations
setup_symlinks() {
    print_status "Setting up dotfiles symlinks..."

    # Backup existing files
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

    # Define symlinks: source_file:target_location
    local symlinks=(
        "vimrc:$HOME/.vimrc"
        "zshrc:$HOME/.zshrc"
        "bashrc:$HOME/.bashrc"
        "alacritty.toml:$HOME/.config/alacritty/alacritty.toml"
        "tmux.conf:$HOME/.tmux.conf"
        "gitconfig:$HOME/.gitconfig"
    )

    # Create backup directory if we need to backup anything
    local need_backup=false

    for link in "${symlinks[@]}"; do
        IFS=':' read -r source target <<< "$link"

        if [[ -f "$target" && ! -L "$target" ]]; then
            if [[ "$need_backup" == false ]]; then
                mkdir -p "$backup_dir"
                need_backup=true
                print_warning "Backing up existing files to $backup_dir"
            fi
            cp "$target" "$backup_dir/"
        fi
    done

    # Create symlinks
    for link in "${symlinks[@]}"; do
        IFS=':' read -r source target <<< "$link"

        local source_path="$DOTFILES_DIR/$source"

        if [[ -f "$source_path" ]]; then
            # Create directory if it doesn't exist
            mkdir -p "$(dirname "$target")"

            # Remove existing file/symlink
            rm -f "$target"

            # Create symlink
            ln -sf "$source_path" "$target"
            print_success "Linked $source -> $target"
        else
            print_warning "Source file $source_path not found, skipping"
        fi
    done
}

# Install Shell Frameworks
# Installs Oh My Zsh and/or Oh My Bash based on SHELL_CHOICE
# Both add themes, plugins, and helpful features to their respective shells
install_shell_frameworks() {
    case "$SHELL_CHOICE" in
        "zsh")
            install_oh_my_zsh
            ;;
        "bash") 
            install_oh_my_bash
            ;;
        "both")
            install_oh_my_zsh
            install_oh_my_bash
            ;;
    esac
}

# Install Oh My Zsh Shell Framework
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh already installed"
        return 0
    fi

    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
}

# Install Oh My Bash Shell Framework  
install_oh_my_bash() {
    if [[ -d "$HOME/.oh-my-bash" ]]; then
        print_success "Oh My Bash already installed"
        return 0
    fi

    print_status "Installing Oh My Bash..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" "" --unattended
    print_success "Oh My Bash installed"
}

# Setup Shell Enhancements and Integrations
# Configures the CLI tools to work together and adds them to shell configuration
# - Initializes zoxide for smart directory jumping (learns your frequently used dirs)
# - Configures git to use delta for beautiful, side-by-side diffs with syntax highlighting
# These settings make your command line much more efficient and pleasant to use
setup_shell_enhancements() {
    print_status "Setting up shell enhancements..."

    # Initialize zoxide if installed
    if command -v zoxide >/dev/null 2>&1; then
        case "$SHELL_CHOICE" in
            "zsh"|"both")
                if ! grep -q "zoxide init" "$HOME/.zshrc" 2>/dev/null; then
                    echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
                    print_success "Added zoxide initialization to .zshrc"
                fi
                ;;
        esac
        
        case "$SHELL_CHOICE" in
            "bash"|"both")
                if ! grep -q "zoxide init" "$HOME/.bashrc" 2>/dev/null; then
                    echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
                    print_success "Added zoxide initialization to .bashrc"
                fi
                ;;
        esac
    fi

    # Setup git delta configuration
    if command -v delta >/dev/null 2>&1; then
        print_status "Configuring git delta..."
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.side-by-side true
        git config --global delta.line-numbers true
        print_success "Git delta configured"
    fi

    print_success "Shell enhancements configured"
}

# Setup Additional System Configurations
# Creates necessary directories that some applications expect
# - vim backup/swap/undo directories (prevents vim temp files cluttering your projects)
# - alacritty config directory (for terminal emulator settings)
# These are standard locations that tools look for but don't auto-create
setup_additional() {
    print_status "Setting up additional configurations..."

    # Create vim directories
    mkdir -p ~/.vim/{backup,swap,undo}

    # Create alacritty config directory
    mkdir -p ~/.config/alacritty

    print_success "Additional setup complete"
}

# Setup Automated Dotfiles Backup
# Creates a cron job that automatically backs up your dotfiles to git every hour
# - Only commits and pushes if there are actual changes (won't spam empty commits)
# - Uses your backup script that creates timestamped commit messages
# - Runs in background, you'll never notice it unless you check git history
# - This is your safety net - you can still manually use 'backup' command for immediate backup
# - If backup files don't exist in repo, gracefully skips this step
setup_autobackup() {
    print_status "Setting up automated backup scripts..."

    local scripts_configured=0

    # Setup dotfiles backup
    if [[ -f "$DOTFILES_DIR/auto_backup_dotfiles.sh" ]]; then
        chmod +x "$DOTFILES_DIR/auto_backup_dotfiles.sh"
        sed -i.bak "s|DOTFILES_DIR=.*|DOTFILES_DIR=\"$DOTFILES_DIR\"|" "$DOTFILES_DIR/auto_backup_dotfiles.sh"
        (crontab -l 2>/dev/null; echo "0 * * * * $DOTFILES_DIR/auto_backup_dotfiles.sh >> /tmp/dotfiles_backup.log 2>&1") | crontab -
        print_success "Dotfiles backup configured"
        ((scripts_configured++))
    else
        print_warning "Dotfiles backup script not found, skipping"
    fi

    # Setup KB backup
    if [[ -f "$DOTFILES_DIR/auto_backup_kb.sh" ]]; then
        chmod +x "$DOTFILES_DIR/auto_backup_kb.sh"
        sed -i.bak "s|KB_DIR=.*|KB_DIR=\"$DOTFILES_DIR/../kb\"|" "$DOTFILES_DIR/auto_backup_kb.sh"
        (crontab -l 2>/dev/null; echo "0 * * * * $DOTFILES_DIR/auto_backup_kb.sh >> /tmp/kb_backup.log 2>&1") | crontab -
        print_success "Knowledge base backup configured"
        ((scripts_configured++))
    else
        print_warning "KB backup script not found, skipping"
    fi

    if [[ $scripts_configured -gt 0 ]]; then
        print_success "Automated backup scripts configured (run hourly, logs in /tmp/)"
    else
        print_warning "No backup scripts found to configure"
    fi
}

# Main execution
main() {
    # Parse command line arguments first
    parse_arguments "$@"
    
    print_status "Starting CLI development environment setup for $SHELL_CHOICE..."
    echo

    # Show what will be installed
    cat << EOF
This script will set up a complete modern CLI development environment:

1. 📦 Install Homebrew package manager (if not already installed)

2. 🛠️  Install modern CLI tools to replace basic Unix commands:
   • fzf (fuzzy finder) - Ctrl+R for history, Ctrl+T for files
   • ripgrep (rg) - faster, better grep with syntax highlighting
   • bat - cat with syntax highlighting and git integration
   • eza - ls with colors, icons, and git status
   • fd - faster, more user-friendly find command
   • git-delta - beautiful side-by-side git diffs
   • lazygit - terminal UI for git operations
   • btop - beautiful system monitor
   • alacritty - modern terminal emulator
   • FiraCode Nerd Font - programming font with icons

3. 🔗 Create symbolic links from this dotfiles repo to home directory
   (backs up existing configs first)

4. 🐚 Install shell framework (Oh My Zsh/Bash) for enhanced shell experience

5. ⚙️  Configure shell integrations:
   • zoxide for smart directory jumping (learns your patterns)
   • git delta for beautiful diffs

6. 🤖 Setup automated hourly backup of dotfiles to git
   (only commits when there are actual changes)

After completion, restart terminal or run 'source ~/.zshrc'

EOF

    read -p "Continue? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_status "Setup cancelled"
        exit 0
    fi

    # Run setup steps
    install_homebrew
    echo

    install_cli_tools
    echo

    verify_dotfiles
    echo

    setup_symlinks
    echo

    install_shell_frameworks
    echo

    setup_additional
    echo

    setup_shell_enhancements
    echo

    setup_autobackup
    echo

    print_success "Setup complete!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"

    # Show installed tools
    echo
    print_status "Installed tools:"
    echo "  zoxide - smart directory jumping (z command)"
    echo "  fzf - Ctrl+R (history), Ctrl+T (files)"
    echo "  rg - ripgrep for fast searching"
    echo "  bat - better cat with syntax highlighting"
    echo "  eza - better ls with colors"
    echo "  fd - better find"
    echo "  dust - better disk usage"
    echo "  lazygit - git TUI"
    echo "  btop - system monitor"
    echo "  ncdu - disk usage analyzer"
    echo "  tree - directory structure"
    echo "  git-delta - beautiful git diffs"

    echo
    print_status "Basic usage examples:"
    echo
    echo "📁 Navigation & Files:"
    echo "  z proj          # Jump to any directory containing 'proj'"
    echo "  z documents     # Jump to documents folder"
    echo "  eza -la         # List all files with icons and git status"
    echo "  fd filename     # Find files by name"
    echo "  fd -t f '.js'   # Find all .js files"
    echo
    echo "🔍 Search & Content:"
    echo "  rg 'pattern'    # Search for text in files"
    echo "  rg 'todo' -i    # Case-insensitive search"
    echo "  bat file.txt    # Display file with syntax highlighting"
    echo "  bat file.js     # Works great with code files"
    echo
    echo "🗂️  System & Management:"
    echo "  dust            # Show disk usage visually"
    echo "  dust -d 2       # Limit depth to 2 levels"
    echo "  ncdu            # Interactive disk usage browser"
    echo "  btop            # Beautiful system monitor"
    echo "  tree -L 2       # Show directory tree, 2 levels deep"
    echo
    echo "⚡ Productivity:"
    echo "  fzf             # Fuzzy find files in current directory"
    echo "  Ctrl+R          # Fuzzy search command history"
    echo "  Ctrl+T          # Fuzzy find files to paste path"
    echo "  lazygit         # Beautiful git interface"
    echo
    echo "📝 Git with Delta:"
    echo "  git diff        # Now shows beautiful side-by-side diffs"
    echo "  git log -p      # View commits with pretty diffs"
    echo "  git show HEAD   # Show last commit with formatting"
}

# Run main function
main "$@"

