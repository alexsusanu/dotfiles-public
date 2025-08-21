" Leader key (do this first)
" The leader key is like a prefix for custom shortcuts
" Example: if leader is ',' then ',w' becomes a shortcut for save
let mapleader = ","

" Basic Settings
set nocompatible                " Don't try to be compatible with old vi
set encoding=utf-8              " Use UTF-8 encoding for all files
set backspace=indent,eol,start  " Allow backspace to delete indents, line breaks, and pre-existing text

" Fix the copy/paste between vim and system
" Makes vim use system clipboard automatically when you yank/paste
" Example: 'yy' copies line to system clipboard, 'p' pastes from system clipboard
set clipboard=unnamed
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" Line numbers and visual aids
set number          " Show absolute line numbers on the left
set relativenumber  " Show relative line numbers (current line = 0, +1, +2, etc)
                    " Example: makes it easy to do '5j' to jump 5 lines down
set cursorline      " Highlight the current line you're on
set showmatch       " Highlight matching parentheses/brackets when cursor is on one
set ruler           " Show cursor position (line, column) in bottom right
set laststatus=2    " Always show status line (filename, line info, etc)

" Search improvements
set ignorecase  " Ignore case when searching (searching 'hello' finds 'Hello', 'HELLO', etc)
set smartcase   " Override ignorecase if search contains uppercase (searching 'Hello' only finds 'Hello')
set incsearch   " Show search matches as you type (highlights matches while typing '/search')
set hlsearch    " Highlight all search matches after pressing Enter (use :noh to clear)

" Tab and indentation
set tabstop=4     " Tab characters appear as 4 spaces wide
set shiftwidth=4  " Use 4 spaces for each indent level (when using >> or << commands)
set softtabstop=4 " When pressing Tab, insert 4 spaces
set expandtab     " Convert all tabs to spaces (prevents tab/space mixing)
set autoindent    " Copy indent from current line when starting new line
set smartindent   " Smart autoindenting for code (adds extra indent after '{', etc)

" File handling and backup
set autoread                    " Automatically reload files changed outside vim
set hidden                      " Allow switching between unsaved buffers (don't force save before switching files)
set backup                      " Keep backup files when saving
set backupdir=~/.vim/backup//   " Store backup files in specific directory (// means use full path)
set directory=~/.vim/swap//     " Store swap files in specific directory (prevents cluttering project dirs)
set undodir=~/.vim/undo//       " Store undo history in specific directory
set undofile                    " Keep undo history between vim sessions (can undo after reopening file)

" Create backup directories if they don't exist
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif

" Mouse support
set mouse=a

" Better command completion
set wildmenu
set wildmode=longest,list,full

" Performance improvements
set lazyredraw
set ttyfast

" Key mappings
" Clear search highlighting
nnoremap <Leader>h :nohlsearch<CR>

" Quick save and quit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

" Better window navigation - move cursor between panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Disable accidental window swapping/moving commands
" These prevent you from accidentally messing up your window layout:
" Disable Ctrl+W x (swap panes)
nnoremap <C-w>x <Nop>
" Disable Ctrl+W r (rotate panes)
nnoremap <C-w>r <Nop>
" Disable Ctrl+W R (rotate panes backward)
nnoremap <C-w>R <Nop>
" Disable Ctrl+W H (move pane to far left)
nnoremap <C-w>H <Nop>
" Disable Ctrl+W J (move pane to bottom)
nnoremap <C-w>J <Nop>
" Disable Ctrl+W K (move pane to top)
nnoremap <C-w>K <Nop>
" Disable Ctrl+W L (move pane to far right)
nnoremap <C-w>L <Nop>
                        " You can still move CURSOR between panes with Ctrl+h/j/k/l

" Better copy/paste (visual mode to system clipboard)
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Syntax and colors
syntax enable
set background=dark

" Show whitespace
set list
set listchars=tab:→\ ,trail:·,nbsp:·

" Auto-reload vimrc when editing it
autocmd BufWritePost .vimrc source %

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" ====================================================================
" SEARCH ACROSS FILES (Grep Integration)
" ====================================================================
" Configure vim to use ripgrep for searching across all files
if executable('rg')
    " Use ripgrep with vim-friendly output (includes filename:line:column)
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

" Search mappings with examples:
" Usage: ',g function' searches for 'function' in all files
nnoremap <Leader>g :grep<space>
" Usage: ',f script' then type to get '*script*'
nnoremap <Leader>f :find<space>*<Left>

" Navigate search results:
" Usage: ',n' go to next search result
nnoremap <Leader>n :cnext<CR>
" Usage: ',N' go to previous search result
nnoremap <Leader>N :cprev<CR>
" Usage: ',l' open list of all search results in bottom window
nnoremap <Leader>l :copen<CR>
" Usage: ',c' close the search results window
nnoremap <Leader>c :cclose<CR>

" ====================================================================
" CODE COMPLETION (Built-in)
" ====================================================================
" Configure vim's built-in completion features
set omnifunc=syntaxcomplete#Complete    " Enable syntax-aware completion (Ctrl+X Ctrl+O)
set complete+=k                         " Include dictionary words in completion

" Usage examples:
" - Type part of word, press Ctrl+N for next completion, Ctrl+P for previous
" - Press Ctrl+X Ctrl+O for smarter completion based on file type
" - Press Ctrl+X Ctrl+F for filename completion

" ====================================================================
" FILE FINDING IMPROVEMENTS
" ====================================================================
" Make vim better at finding files in your project
set path+=**                    " Search recursively into subdirectories with :find
                               " Usage: ':find config.js' will search entire project tree
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/build/*    " Ignore common directories when searching

" Usage examples:
" - ':find *.js' finds all JavaScript files in project
" - ':find config' finds any file with 'config' in the name
" - Tab completion works with :find


