" syntax highlighting
filetype plugin indent on
syntax on


" ################################################
"                Plugin Installation
" ################################################

" Enable plugins using vim-plug
call plug#begin()

" Install fzf, a fuzzy finder plugin for vim
Plug 'junegunn/fzf'

" Install extra scripts for fzf
Plug 'junegunn/fzf.vim'

" Install dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

" Install vim-cpp-modern for better syntax highlighting
Plug 'bfrg/vim-cpp-modern'

" Add airline
Plug 'vim-airline/vim-airline'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" ################################################
"                Extension settings
" ################################################

" ## Airline settings ##
" enable powerline glyphs in airline
let g:airline_powerline_fonts=1
" enable list of buffers
let g:airline#extensions#tabline#enabled=1
" format tabline with just filename
let g:airline#extensions#tabline#fnamemod = ':t'

" ################################################
"                Keyboard shortcuts
" ################################################

" ## Leader key ##
let mapleader = ","

" ## Buffer management ##
" setup shortcuts to work with buffers more effectively
" we use buffers somewhat like tabs in a traditional IDE
"
" Move to next buffer
nmap <leader>n :bnext<CR>
" Move to previous buffer
nmap <leader>p :bprevious<CR>
" Close current buffer, replaces :q for this setup
nmap <leader>q :bprevious <BAR> :bdelete #<CR>

" ## FZF search shortcuts ##
" Fuzzy search files in current directory
nmap <leader>sf :Files<CR>
" Fuzzy search files in home director
nmap <leader>sh :Files ~<CR>
" Fuzzy search open buffers
nmap <leader>sb :Buffers<CR>

" ################################################
"                Custom commands
" ################################################
" Open a terminal instance.
" Marks the buffer as unlisted so we won't switch to it
function! CreateTerm()
	execute "terminal"
	execute "set nobuflisted"
endfunction

:command Term call CreateTerm()


" ################################################
"                Editor Settings
" ################################################
"

" Disable X11 clipboard by default.
if $DISPLAY =~ 'localhost:.*'
	set clipboard=autoselect,exclude:.*
endif

" smart indent
set smartindent

" search options
set ignorecase
set smartcase
set incsearch

" make background dark
set background=dark

" enable spellcheck
set spell

" Set colorscheme to dracula
colorscheme dracula

" Use terminal gui colors
set termguicolors

" Strip trailing whitespace from files
autocmd BufWritePre <buffer> %s/\s\+$//e

" 80 column indicator
set colorcolumn=80

" numbering
set number
