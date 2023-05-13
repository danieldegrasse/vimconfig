"syntax highlighting
filetype plugin indent on
syntax on

"Enable plugins using vim-plug
call plug#begin()

"Install fzf, a fuzzy finder plugin for vim
Plug 'junegunn/fzf'

"Install extra scripts for fzf
Plug 'junegunn/fzf.vim'

"Install dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

"Install vim-cpp-modern for better syntax highlighting
Plug 'bfrg/vim-cpp-modern'

"Initialize plugin system
"- Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

"80 column indicator
set colorcolumn=80

"numbering
set number

"default to indentation with tabs
set shiftwidth=8
set softtabstop=0
set noexpandtab
"Toggle between tabs and spaces
function TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

"smart indent
set smartindent

"search options
set ignorecase
set smartcase
set incsearch

"make background dark
set background=dark

"enable spellcheck
set spell

"Set colorscheme to dracula
colorscheme dracula

"Use terminal gui colors
set termguicolors

"Strip trailing whitespace from files
autocmd BufWritePre <buffer> %s/\s\+$//e
