#!/bin/bash

# Complete CLI Development Environment Setup Script for Ubuntu/Debian
#
# PURPOSE: Sets up Ubuntu/Debian with all CLI tools, dotfiles, and configurations
#
# WHAT THIS SCRIPT DOES:
# - Updates package manager and installs essential tools
# - Installs modern CLI tools (fzf, ripgrep, bat, eza, etc.) via apt/snap/manual install
# - Creates symbolic links from this dotfiles repo to home directory
# - Installs Oh My Zsh/Bash for better shell experience
# - Configures git with delta for beautiful diffs
# - Sets up automated hourly backup of dotfiles to git
# - Installs Nerd Fonts for terminal icons
#
# WHEN TO USE: Run this on fresh Ubuntu/Debian or when setting up development environment
# WHERE TO RUN: From inside your dotfiles repository directory

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

Sets up a complete modern CLI development environment with shell frameworks for Ubuntu/Debian.

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

# Update system packages
update_system() {
    print_status "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    print_success "System packages updated"
}

# Install CLI tools
install_cli_tools() {
    print_status "Installing CLI tools..."

    # Install tools available via apt
    local apt_tools=(
        "git"
        "vim"
        "tmux"
        "curl"
        "wget"
        "tree"
        "ncdu"
        "jq"
        "unzip"
        "build-essential"
    )

    for tool in "${apt_tools[@]}"; do
        if dpkg -l | grep -q "^ii  $tool "; then
            print_success "$tool already installed"
        else
            print_status "Installing $tool..."
            sudo apt install -y "$tool"
            print_success "$tool installed"
        fi
    done

    # Install fzf
    if command_exists fzf; then
        print_success "fzf already installed"
    else
        print_status "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        print_success "fzf installed"
    fi

    # Install ripgrep
    if command_exists rg; then
        print_success "ripgrep already installed"
    else
        print_status "Installing ripgrep..."
        curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        sudo dpkg -i ripgrep_13.0.0_amd64.deb
        rm ripgrep_13.0.0_amd64.deb
        print_success "ripgrep installed"
    fi

    # Install bat
    if command_exists bat || command_exists batcat; then
        print_success "bat already installed"
    else
        print_status "Installing bat..."
        curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb
        sudo dpkg -i bat_0.24.0_amd64.deb
        rm bat_0.24.0_amd64.deb
        print_success "bat installed"
    fi

    # Install eza (better ls)
    if command_exists eza; then
        print_success "eza already installed"
    else
        print_status "Installing eza..."
        curl -LO https://github.com/eza-community/eza/releases/download/v0.17.0/eza_x86_64-unknown-linux-gnu.tar.gz
        tar -xzf eza_x86_64-unknown-linux-gnu.tar.gz
        sudo mv eza /usr/local/bin/
        rm eza_x86_64-unknown-linux-gnu.tar.gz
        print_success "eza installed"
    fi

    # Install fd (better find)
    if command_exists fd; then
        print_success "fd already installed"
    else
        print_status "Installing fd..."
        curl -LO https://github.com/sharkdp/fd/releases/download/v8.7.1/fd_8.7.1_amd64.deb
        sudo dpkg -i fd_8.7.1_amd64.deb
        rm fd_8.7.1_amd64.deb
        print_success "fd installed"
    fi

    # Install zoxide (smart cd)
    if command_exists zoxide; then
        print_success "zoxide already installed"
    else
        print_status "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        print_success "zoxide installed"
    fi

    # Install delta (git diff)
    if command_exists delta; then
        print_success "delta already installed"
    else
        print_status "Installing delta..."
        curl -LO https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb
        sudo dpkg -i git-delta_0.16.5_amd64.deb
        rm git-delta_0.16.5_amd64.deb
        print_success "delta installed"
    fi

    # Install dust (better du)
    if command_exists dust; then
        print_success "dust already installed"
    else
        print_status "Installing dust..."
        curl -LO https://github.com/bootandy/dust/releases/download/v0.8.6/du-dust_0.8.6_amd64.deb
        sudo dpkg -i du-dust_0.8.6_amd64.deb
        rm du-dust_0.8.6_amd64.deb
        print_success "dust installed"
    fi

    # Install lazygit
    if command_exists lazygit; then
        print_success "lazygit already installed"
    else
        print_status "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
        print_success "lazygit installed"
    fi

    # Install btop (better htop)
    if command_exists btop; then
        print_success "btop already installed"
    else
        print_status "Installing btop..."
        if command_exists snap; then
            sudo snap install btop
        else
            sudo apt install -y btop
        fi
        print_success "btop installed"
    fi
}

# Install fonts
install_fonts() {
    print_status "Installing Nerd Font for terminal icons..."
    
    # Create fonts directory
    mkdir -p ~/.local/share/fonts
    
    # Download and install FiraCode Nerd Font
    if [[ ! -f ~/.local/share/fonts/FiraCodeNerdFont-Regular.ttf ]]; then
        curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
        unzip FiraCode.zip -d FiraCode
        cp FiraCode/*.ttf ~/.local/share/fonts/
        rm -rf FiraCode FiraCode.zip
        fc-cache -fv
        print_success "Nerd Font installed"
    else
        print_success "Nerd Font already installed"
    fi
}

# Verify Dotfiles Directory
verify_dotfiles() {
    print_status "Using dotfiles from $DOTFILES_DIR"

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi

    print_success "Dotfiles directory verified"
}

# Setup Configuration Symlinks
setup_symlinks() {
    print_status "Setting up dotfiles symlinks..."

    # Backup existing files
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

    # Define symlinks: source_file:target_location
    local symlinks=(
        "vimrc:$HOME/.vimrc"
        "zshrc:$HOME/.zshrc"
        "bashrc:$HOME/.bashrc"
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
setup_additional() {
    print_status "Setting up additional configurations..."

    # Create vim directories
    mkdir -p ~/.vim/{backup,swap,undo}

    print_success "Additional setup complete"
}

# Setup Automated Dotfiles Backup
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
    
    print_status "Starting CLI development environment setup for Ubuntu/Debian ($SHELL_CHOICE)..."
    echo

    # Show what will be installed
    cat << EOF
This script will set up a complete modern CLI development environment on Ubuntu/Debian:

1. 📦 Update system packages

2. 🛠️  Install modern CLI tools:
   • fzf (fuzzy finder) - Ctrl+R for history, Ctrl+T for files
   • ripgrep (rg) - faster, better grep with syntax highlighting
   • bat - cat with syntax highlighting and git integration
   • eza - ls with colors, icons, and git status
   • fd - faster, more user-friendly find command
   • git-delta - beautiful side-by-side git diffs
   • lazygit - terminal UI for git operations
   • btop - beautiful system monitor
   • dust - better disk usage
   • zoxide - smart directory jumping

3. 🔤 Install FiraCode Nerd Font for terminal icons

4. 🔗 Create symbolic links from this dotfiles repo to home directory
   (backs up existing configs first)

5. 🐚 Install shell framework (Oh My Zsh/Bash) for enhanced shell experience

6. ⚙️  Configure shell integrations:
   • zoxide for smart directory jumping (learns your patterns)
   • git delta for beautiful diffs

7. 🤖 Setup automated hourly backup of dotfiles to git
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
    update_system
    echo

    install_cli_tools
    echo

    install_fonts
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