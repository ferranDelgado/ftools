""" === VIM CONFIGURATION ===
" Modern Vim setup with sensible defaults, plugin support, and quality-of-life improvements

"" === BASIC SETTINGS ===
syntax on                          " Enable syntax highlighting
set number                         " Show line numbers
set relativenumber                 " Show relative line numbers (better for motions)
set cursorline                     " Highlight the current line
set cursorcolumn                   " Highlight the current column

"" === TEXT WRAPPING & INDENTATION ===
set textwidth=80                   " Hard wrap at 80 characters
set colorcolumn=80                 " Show visual guide at column 80
set nowrap                         " Don't wrap lines visually by default

set expandtab                      " Use spaces instead of tabs
set tabstop=4                      " Tabs are 4 spaces
set shiftwidth=4                   " Indent with 4 spaces
set softtabstop=4                  " Backspace deletes 4 spaces
set autoindent                     " Automatically indent new lines
set smartindent                    " Smart indentation (respect code blocks)

"" === SEARCH & REPLACE ===
set incsearch                      " Highlight matches as you type
set hlsearch                       " Highlight all search matches
set ignorecase                     " Case-insensitive search by default
set smartcase                      " But case-sensitive if uppercase is used
set gdefault                       " Global flag for :s by default

"" === UI/UX IMPROVEMENTS ===
set mouse=a                        " Enable mouse support in all modes
set clipboard=unnamed,unnamedplus  " Use system clipboard
set backspace=indent,eol,start     " Allow backspace on everything
set showmatch                      " Highlight matching brackets
set matchtime=2                    " Blink matched bracket for 2 tenths of a second
set wildmenu                       " Enhanced command-line completion
set wildmode=list:longest,full     " Complete to longest match, then full
set laststatus=2                   " Always show the status bar
set ruler                          " Show cursor position in status bar
set scrolloff=5                    " Keep 5 lines visible above/below cursor
set sidescrolloff=10               " Keep 10 columns visible left/right

"" === PERFORMANCE & FILES ===
set noswapfile                     " Don't create swap files
set nobackup                       " Don't create backup files
set undofile                       " Persistent undo
set undodir=~/.vim/undo            " Store undo history

if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif

"" === STATUS LINE (Custom) ===
set statusline=%F                  " Full file path
set statusline+=\ %m%r%h%w         " Modified, read-only, help, preview flags
set statusline+=%=                 " Right-align following
set statusline+=%y\ \|\ %{&fileencoding?&fileencoding:&encoding}\ \|\ %p%%\ \|\ %l:%c
" Shows: filetype | encoding | scroll% | line:column

"" === KEY MAPPINGS ===
" Disable arrow keys to use hjkl (optional but good habit)
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>

" Clear search highlighting with Escape in normal mode
nnoremap <Esc> :noh<CR>

" Quick quit and save
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :wq<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" === VIM-PLUG PLUGIN MANAGER (Optional) ===
" Uncomment below to use vim-plug. Install with:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

"call plug#begin('~/.vim/plugged')
"  Plug 'tpope/vim-sensible'        " Sensible defaults for Vim
"  Plug 'vim-airline/vim-airline'   " Lightweight statusline
"  Plug 'junegunn/fzf.vim'          " Fuzzy file search
"  Plug 'tpope/vim-commentary'      " Easy commenting
"  Plug 'tpope/vim-surround'        " Surround text objects
"  Plug 'airblade/vim-gitgutter'    " Git diff in gutter
"  Plug 'preservim/nerdtree'        " File explorer
"call plug#end()

"" === THEME/COLORS (Optional) ===
" Uncomment to use a color scheme (requires the plugin to be installed)
"colorscheme gruvbox
"set background=dark

"" === ADDITIONAL SETTINGS ===
set hidden                         " Allow switching buffers without saving
set history=1000                   " Remember more commands and search history
set splitbelow                     " Open splits below current window
set splitright                     " Open vertical splits to the right