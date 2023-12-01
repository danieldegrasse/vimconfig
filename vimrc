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
" show buffer number in tabline
let g:airline#extensions#tabline#buffer_nr_show = 1

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

" Enable whitespace stripping by default
let g:EnableWStrip = 1

" This function strips whitespace from a file, when the setting is enabled.
" Otherwise is is a no-op.
function! TrimWhiteSpace()
	if g:EnableWStrip
		" Set mark at current position
		normal mZ
		" Strip whitespace
		%s/\s\+$//e
		" Check if cursor moved, if so alert user we removed
		" whitespace
		if line("'Z") != line(".")
			echo "Stripped whitespace\n"
		endif
		" Jump back to mark
		normal `Z
	endif
endfunction

" Run whitespace strip function before buffer write
autocmd BufWritePre * call TrimWhiteSpace()

command EnableWStrip let g:EnableWStrip=1
command DisableWStrip let g:EnableWStrip=0

" Set the width of a tab. Useful when editing files
" Where the filetype plugin selects the wrong indentation standard
function! SetTabWidth(num)
	if a:num == 8
		" Using tabs, don't expand tabs to spaces
		set noexpandtab
		let &softtabstop=8
		let &shiftwidth=8
	else
	    set expandtab
		let &softtabstop=a:num
		let &shiftwidth=a:num
	endif
endfunction

command -nargs=1 TabSpacing call SetTabWidth(<f-args>)


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

" This function gets a link to a specific line of code in the current file
" on Github. It can be used to refer to code by a link that is being viewed
" in a local editor
function! GitHubLink()
	" Get current line number
	let pos = getpos('.')
	let linenum = pos[1]
	" Get directory of file, for use with Git commandline
	let file_dir = expand('%:p:h')
	" List git remotes
	let git_remotes = systemlist('git -C ' . file_dir . ' remote')
	" Use upstream as remote if it exists, or fall back to origin
	if index(git_remotes, "upstream") != -1
		let cmd = 'git -C ' . file_dir . ' remote get-url upstream'
	else
		let cmd = 'git -C ' . file_dir . ' remote get-url origin'
	endif
	let remote = trim(system(cmd))
	" Trim .git suffix on url
	let remote = substitute(remote, '.git$', '', '')
	let cmd = 'git -C ' . file_dir . ' ls-files --full-name ' . expand('%:p')
	let git_file = trim(system(cmd))
	" Abuse a feature of the github API- using master as branch name
	" always seems to redirect us to default branch
	let url = remote . '/tree/master/' . git_file . '#L' . linenum
	echo url
endfunction

" ################################################
"                Editor Settings
" ################################################
"

" Disable X11 clipboard by default.
if $DISPLAY =~ 'localhost:.*'
	set clipboard=autoselect,exclude:.*
endif

" Setup windows specific options
if has('win32') || has('win64')
	set backspace=2
endif

" use cindent, this takes precedence over smartindent
set cindent
" Set cindent options to indent aligning with parenthesis
" and remove case label indents
set cinoptions=(0:0

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

" set gui font to one with powerline glyphs
set guifont=CaskaydiaCove\ Nerd\ Font\ Mono
