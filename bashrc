# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/Users/alex/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="cooperkid"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"

# GO STUFF
export GO111MODULE=off

# GIT SETUP START ===============================
# GIT aliases
alias gc='git commit -m'
alias gs='git status'
alias gpl='git pull'
alias gph='git push'

##### PUSH TO github gitlab codeberg

gph3() {
    # Push to current branch

    local branch=$(git branch --show-current)

    # Push changes to the GitHub remote
    git push github "$branch"
    # Check if the push was successful or if there was nothing to push
    if [ $? -eq 0 ]; then
        echo "Everything up-to-date github"
    else
        echo "Push to github failed"
    fi

    # Push changes to the Codeberg remote
    git push codeberg "$branch"
    # Check if the push was successful or if there was nothing to push
    if [ $? -eq 0 ]; then
        echo "Everything up-to-date codeberg"
    else
        echo "Push to codeberg failed"
    fi

   # UNCOMMENT THIS AFTER GITLAB SETUP
   # # Push changes to the GitLab remote
   # git push gitlab "$branch"
   # # Check if the push was successful or if there was nothing to push
   # if [ $? -eq 0 ]; then
   #     echo "Everything up-to-date gitlab"
   # else
   #     echo "Push to gitlab failed"
   # fi
}

###### create and push initial repo to 2

create2repo() {
    if [ $# -eq 0 ]; then
        echo "Usage: create_and_push_repo <repo_name>"
        return 1
    fi

    repo_name="$1"

    # Initialize a new Git repository
    echo "# ${repo_name%.*}" >> README.md
    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main

    # Add GitHub remote
    git remote add github "git@github.com:alexsusanu/$repo_name"
    git push -u github main

    # Add GitLab remote
    git remote add gitlab "git@gitlab.com:g5873/$repo_name"
    git push --set-upstream gitlab --all
    git push --set-upstream gitlab --tags

}
# GIT SETUP STOP ===============================


backup() {
    git add . && git commit -m "backup $(date '+%Y-%m-%d %H:%M')" && gph3
}

# CLI aliases
alias c='clear'
alias h='history'
alias uu='uuidgen | pbcopy'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias view='python3 -m http.server'
alias chrome="open -a 'Google Chrome'"
alias dt='capture_date'

capture_date() {
    datetime=$(date -v -2H +"%Y-%m-%dT%H:%M:%S")
    echo -n $datetime | pbcopy
    echo "Copied $datetime to clipboard"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Better aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias tree='eza --tree'
alias cat='bat --color=always'
alias less='less -R'
alias grep='rg -i'
alias find='fd'

# fzf options
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# github copilot alias
alias cox="gh copilot explain"
alias cos="gh copilot suggest"

# Zoxide Integration for ~/.bashrc

# What this does:
# eval "$(zoxide init bash)" sets up zoxide integration in your bash shell
#
# Breaking it down:
# - `zoxide init bash` generates shell code to integrate zoxide with bash
# - `$()` command substitution, runs the command and captures output
# - `eval` executes the captured output as shell commands
#
# What it actually does:
# - Creates the `z` command for smart directory jumping
# - Sets up command history tracking so zoxide learns your patterns
# - Adds shell hooks to monitor directory changes
#
# Usage examples after adding this:
# - `z documents` jumps to ~/Documents (or any directory matching "documents")
# - `z proj` jumps to ~/workspace/my-project (if you've visited it before)
# - `zi` opens interactive directory picker
# - `z` with no args shows your most used directories
#
# Without this line: zoxide is installed but not integrated (no `z` command)
# With this line: `z` command works and learns your directory patterns

eval "$(zoxide init bash)"

# CLI Help Function for ~/.bashrc
# Add this to your ~/.bashrc file

cli_help() {
    echo
    echo "🚀 CLI Tools Quick Reference"
    echo "=============================="
    echo

    case $1 in
        ""|"all")
            echo "📋 All Tools Overview:"
            echo "  fzf        - Fuzzy finder (Ctrl+R, Ctrl+T)"
            echo "  grep       - Fast text search (rg -i)"
            echo "  find       - Better file finder (fd)"
            echo "  cat        - Cat with syntax highlighting (bat)"
            echo "  ls/ll      - ls with colors and icons (eza)"
            echo "  tree       - Directory structure (eza --tree)"
            echo "  z          - Smart directory jumping"
            echo "  dust       - Visual disk usage"
            echo "  btop       - System monitor"
            echo "  lazygit    - Git TUI"
            echo "  ncdu       - Interactive disk usage"
            echo "  delta      - Beautiful git diffs"
            echo
            echo "💡 Use: cli_help <tool_name> for specific help"
            ;;
        "fzf")
            echo "🔍 fzf - Fuzzy Finder"
            echo "  fzf                  # Search files in current directory"
            echo "  Ctrl+R               # Fuzzy search command history"
            echo "  Ctrl+T               # Fuzzy find files, paste path"
            echo "  Alt+C                # Fuzzy find directories, cd into it"
            ;;
        "rg"|"ripgrep"|"grep")
            echo "🔍 rg/grep - Fast Search"
            echo "  grep 'function'      # Find 'function' in all files (case-insensitive)"
            echo "  grep 'todo'          # Find all TODO comments"
            echo "  rg 'error' --type js # Search only in JavaScript files"
            echo "  rg 'import' -A 3     # Show 3 lines after each match"
            echo "  rg 'class.*User'     # Use regex to find class definitions"
            ;;
        "fd"|"find")
            echo "📁 fd/find - Better Find"
            echo "  find config.js       # Find files named 'config.js'"
            echo "  find '*.py'          # Find all Python files"
            echo "  fd -t d node_modules # Find directories named 'node_modules'"
            echo "  fd -e js src/        # Find all .js files in src/ folder"
            echo "  fd -H .env           # Include hidden files like .env"
            ;;
        "bat"|"cat")
            echo "📄 bat/cat - Better Cat"
            echo "  cat script.py        # View Python file with syntax highlighting"
            echo "  cat README.md        # View markdown with formatting"
            echo "  bat -n config.js     # Show with line numbers"
            echo "  bat -A .env          # Show all characters (tabs, spaces, etc)"
            ;;
        "eza"|"ls"|"ll")
            echo "📂 eza/ls/ll - Better ls"
            echo "  ls                   # List files with colors and icons"
            echo "  ll                   # Long format with permissions, dates, sizes"
            echo "  ls src/              # List files in specific directory"
            echo "  eza --git            # Show git status (modified, staged, etc)"
            echo "  eza --sort=size      # Sort by file size"
            ;;
        "z"|"zoxide")
            echo "🚀 z (zoxide) - Smart Directory Jumping"
            echo "  z workspace          # Jump to ~/workspace or any workspace folder"
            echo "  z dotfiles           # Jump to dotfiles directory"
            echo "  z proj web           # Match directories with both 'proj' and 'web'"
            echo "  zi                   # Interactive fuzzy directory picker"
            ;;
        "dust")
            echo "💾 dust - Disk Usage"
            echo "  dust                 # See what's taking up space visually"
            echo "  dust ~/Downloads     # Check Downloads folder size"
            echo "  dust -d 3            # Show 3 levels deep max"
            echo "  dust -r              # Show largest files first"
            ;;
        "btop")
            echo "⚡ btop - System Monitor"
            echo "  btop                 # Beautiful system monitor"
            echo "  q                    # Quit btop"
            echo "  m                    # Toggle memory view"
            echo "  p                    # Toggle process view"
            ;;
        "tree")
            echo "🌳 tree - Directory Structure"
            echo "  tree                 # Show project structure (eza --tree)"
            echo "  tree -L 2            # Show only 2 levels deep (easier to read)"
            echo "  eza --tree -a        # Include hidden files (.git, .env, etc)"
            echo "  eza --tree -I node_modules # Ignore large folders"
            ;;
        "lazygit")
            echo "🔧 lazygit - Git TUI"
            echo "  lazygit              # Visual git - see changes, stage, commit"
            echo "  Space                # Stage/unstage files"
            echo "  c                    # Commit staged changes"
            echo "  P                    # Push to remote"
            ;;
        "ncdu")
            echo "💽 ncdu - Interactive Disk Usage"
            echo "  ncdu                 # Navigate folders, see sizes interactively"
            echo "  ncdu ~/Downloads     # Browse Downloads folder"
            echo "  Enter                # Enter directory"
            echo "  d                    # Delete file/folder (be careful!)"
            ;;
        "delta")
            echo "🎨 delta - Beautiful Git Diffs"
            echo "  git diff             # See changes with syntax highlighting"
            echo "  git log -p --oneline # View recent commits with diffs"
            echo "  git show HEAD        # Show last commit nicely formatted"
            echo "  git diff --cached    # See staged changes before commit"
            ;;
        *)
            echo "❓ Available tools:"
            echo "  fzf, grep, find, cat, ls, ll, tree, z, dust, btop, lazygit, ncdu, delta"
            echo
            echo "Usage: cli_help <tool_name>"
            echo "       cli_help all"
            ;;
    esac
    echo
}

# Alias for shorter command
alias ch='cli_help'

source ~/dotfiles/scripts/htb_wrapper.sh

# Diary function for ~/.bashrc
# Creates separate files for each day

diary() {
    local file=~/diary/$(date '+%Y-%m-%d').txt
    mkdir -p ~/diary

    echo "=== $(date '+%H:%M') ===" >> "$file"

    if [[ $# -eq 0 ]]; then
        echo "Enter your diary entry (Ctrl+D to finish):"
        cat >> "$file"
    else
        echo "$*" >> "$file"
    fi

    echo "" >> "$file"  # blank line separator
    echo "Entry added to $file"
}

# Usage:
# diary "Quick one-liner entry"
# OR
# diary
# (then type multiple lines, press Ctrl+D when done)

# Tmux Help Function for ~/.zshrc
# Based on your custom tmux.conf with Ctrl+A prefix

tmux_help() {
    echo
    echo "🖥️  Tmux Quick Reference (Prefix: Ctrl+A)"
    echo "========================================"
    echo

    case $1 in
        ""|"all")
            echo "📋 Common Commands:"
            echo "  split     - Split windows/panes"
            echo "  move      - Move between panes"
            echo "  windows   - Window management"
            echo "  session   - Session management"
            echo
            echo "💡 Use: tmux_help <command> for specific help"
            echo "💡 Your prefix key is Ctrl+A (not Ctrl+B)"
            ;;
        "split"|"panes")
            echo "✂️  Split Panes:"
            echo "  Ctrl+A |         # Split window horizontally (left|right)"
            echo "  Ctrl+A -         # Split window vertically (top/bottom)"
            echo "  Ctrl+A x         # Kill current pane"
            echo "  Ctrl+A z         # Toggle pane zoom (fullscreen current pane)"
            ;;
        "move"|"switch"|"navigate")
            echo "🔀 Move Between Panes:"
            echo "  Alt+←           # Move to left pane (NO PREFIX needed)"
            echo "  Alt+→           # Move to right pane (NO PREFIX needed)"
            echo "  Alt+↑           # Move to pane above (NO PREFIX needed)"
            echo "  Alt+↓           # Move to pane below (NO PREFIX needed)"
            ;;
        "windows"|"window")
            echo "🪟 Window Management:"
            echo "  Ctrl+A c         # Create new window"
            echo "  Ctrl+A n         # Next window"
            echo "  Ctrl+A p         # Previous window"
            echo "  Ctrl+A 0-9       # Switch to window number"
            echo "  Ctrl+A &         # Kill current window"
            echo "  Ctrl+A ,         # Rename current window"
            ;;
        "session"|"sessions")
            echo "📦 Session Management:"
            echo "  tmux new -s name # Create new session with name"
            echo "  tmux ls          # List all sessions"
            echo "  tmux attach -t name # Attach to session"
            echo "  Ctrl+A d         # Detach from session"
            echo "  Ctrl+A s         # Switch between sessions"
            ;;
        "config"|"reload")
            echo "⚙️  Config & Reload:"
            echo "  Ctrl+A r         # Reload tmux config"
            echo "  ~/.tmux.conf     # Your config file location"
            ;;
        *)
            echo "❓ Available topics:"
            echo "  split, move, windows, session, config"
            echo
            echo "Usage: tmux_help <topic>"
            ;;
    esac
    echo
}

# Alias for shorter command
alias th='tmux_help'

# Vim Help Function for ~/.zshrc
# Based on your custom vimrc configuration

vim_help() {
    echo
    echo "📝 Vim Quick Reference (Your Custom Setup)"
    echo "=========================================="
    echo

    case $1 in
        ""|"all")
            echo "📋 Available Topics:"
            echo "  basic     - Basic movement and editing"
            echo "  files     - File operations and navigation"
            echo "  search    - Search and replace"
            echo "  windows   - Window/pane management"
            echo "  tree      - File explorer (built-in)"
            echo "  complete  - Code completion"
            echo "  custom    - Your custom shortcuts"
            echo
            echo "💡 Use: vim_help <topic> for specific help"
            echo "💡 Your leader key is ',' (comma)"
            ;;
        "basic"|"movement")
            echo "🚀 Basic Movement & Editing:"
            echo "  h j k l              # Left, down, up, right"
            echo "  w b                  # Next word, previous word"
            echo "  0 $                  # Start of line, end of line"
            echo "  gg G                 # Top of file, bottom of file"
            echo "  5G                   # Go to line 5"
            echo "  i a o                # Insert before cursor, after cursor, new line below"
            echo "  x dd yy p            # Delete char, delete line, copy line, paste"
            echo "  u Ctrl+r             # Undo, redo"
            ;;
        "files"|"file")
            echo "📁 File Operations:"
            echo "  ,w                   # Quick save (:w)"
            echo "  ,q                   # Quick quit (:q)"
            echo "  :e filename          # Open/edit file"
            echo "  :find config.js      # Find file in project (recursive search)"
            echo "  :find *.py           # Find all Python files"
            echo "  ,f filename          # Quick find files"
            echo "  Ctrl+h/j/k/l         # Move between windows"
            ;;
        "search"|"find")
            echo "🔍 Search Operations:"
            echo "  /pattern             # Search forward for pattern"
            echo "  ?pattern             # Search backward for pattern"
            echo "  n N                  # Next match, previous match"
            echo "  ,h                   # Clear search highlighting"
            echo "  ,g pattern           # Search across all files (uses ripgrep)"
            echo "  ,n ,N                # Next/previous search result across files"
            echo "  ,l                   # Open list of search results"
            echo "  ,c                   # Close search results list"
            ;;
        "windows"|"panes")
            echo "🪟 Window Management:"
            echo "  Ctrl+h/j/k/l         # Move cursor between windows"
            echo "  :split               # Split window horizontally"
            echo "  :vsplit              # Split window vertically"
            echo "  Ctrl+w c             # Close current window"
            echo "  Ctrl+w o             # Close all other windows"
            echo "  Ctrl+w =             # Resize all windows equally"
            echo "  :vertical resize 30  # Resize current window to 30 columns"
            echo
            echo "🚫 Disabled (prevents accidental layout changes):"
            echo "  Ctrl+w x, r, H, J, K, L are disabled"
            ;;
        "tree"|"explorer")
            echo "🌳 File Explorer (Built-in Netrw):"
            echo "  ,e                   # Toggle file explorer"
            echo "  vim .                # Open vim with file explorer"
            echo
            echo "📂 Inside File Explorer:"
            echo "  Enter                # Open file/folder"
            echo "  -                    # Go up one directory"
            echo "  D                    # Delete file"
            echo "  R                    # Rename file"
            echo "  %                    # Create new file"
            echo "  d                    # Create new directory"
            echo "  Ctrl+h/l             # Switch between explorer and file"
            ;;
        "complete"|"completion")
            echo "🤖 Code Completion:"
            echo "  Ctrl+n               # Next word completion"
            echo "  Ctrl+p               # Previous word completion"
            echo "  Ctrl+x Ctrl+o        # Smart completion (based on file type)"
            echo "  Ctrl+x Ctrl+f        # File name completion"
            echo "  Ctrl+x Ctrl+l        # Complete whole line"
            echo
            echo "💡 Start typing, then use above keys for suggestions"
            ;;
        "custom"|"shortcuts")
            echo "⚙️  Your Custom Shortcuts (Leader = ,):"
            echo "  ,w                   # Save file"
            echo "  ,q                   # Quit file"
            echo "  ,h                   # Clear search highlighting"
            echo "  ,e                   # Toggle file explorer"
            echo "  ,g pattern           # Search in all files"
            echo "  ,f filename          # Find files by name"
            echo "  ,n ,N                # Navigate search results"
            echo "  ,l                   # Open search results list"
            echo "  ,c                   # Close search results"
            echo "  ,y ,Y                # Copy to system clipboard (visual mode)"
            echo "  ,p ,P                # Paste from system clipboard"
            ;;
        *)
            echo "❓ Available topics:"
            echo "  basic, files, search, windows, tree, complete, custom"
            echo
            echo "Usage: vim_help <topic>"
            ;;
    esac
    echo
}

# Alias for shorter command
alias vh='vim_help'

# Better completion settings for ~/.bashrc

# Enable programmable completion (if available)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Case insensitive completion
bind "set completion-ignore-case on"

# Show all matches if there are multiple completions
bind "set show-all-if-ambiguous on"

# Menu-style completion - cycle through matches with Tab
bind "set menu-complete-display-prefix on"
bind '"\t": menu-complete'

# Usage:
# - Type 'cd doc<Tab>' and it will complete to 'Documents/'
# - If multiple matches, press Tab repeatedly to cycle through them
# - Case doesn't matter: 'CD doc<Tab>' also works

