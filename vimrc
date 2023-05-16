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

command Term call CreateTerm()

" Strip whitespace from file
command WStrip :%s/\s\+$//e


" Open a FZF window with ripgrep. If a directory is provided, search
" there. Otherwise use $PWD.
function! LaunchRg(dir)
	" Get directory, default to PWD if the argument is empty
	if len(a:dir) == 0
		" Fallback to CWD
		let path = getcwd()
	else
		let directory = a:dir
		let path = system('realpath '.shellescape(directory))[:-2]
		if !isdirectory(path)
			echo "Directory not found: ".path
			" Error here, don't launch FZF Rg window
			return 1
		endif
	endif
	" Note- the shellescape('') seems to be needed here. Unclear why.
	call fzf#vim#grep("rg --column --line-number --no-heading
		\ --color=always --smart-case -- ".shellescape(''), 1,
	        \ fzf#vim#with_preview({'dir': path}), 0)
endfunction

" Replace standard Rg command to instead launch our Rg function
command! -complete=file -nargs=* Rg call LaunchRg(<q-args>)

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

" 80 column indicator
set colorcolumn=80

" numbering
set number
