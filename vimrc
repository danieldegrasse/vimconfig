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

" Install gruvbox theme
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }

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
		let path = expand(directory)
		if !isdirectory(path)
			echo "Directory not found: ".path
			" Error here, don't launch FZF Rg window
			return 1
		endif
	endif
	" Note- the shellescape('') seems to be needed here. Unclear why.
	call fzf#vim#grep("rg --column --line-number --no-heading
		\ --color=always --smart-case -- ".shellescape(''), 1,
	        \ fzf#vim#with_preview({'dir': path, 'options':
		\ '--delimiter : --nth 4..'}), 0)
endfunction

" Replace standard Rg command to instead launch our Rg function
command! -complete=dir -nargs=* Rg call LaunchRg(<q-args>)

" Open FZF window with fdfind. If the current working directory contains
" a file named 'fzf.conf', source it and use the SEARCH_DIRS variable to
" determine which directories to search.
" If a file path is provided, search it directly, without reading fzf.conf.
function! SmartFiles(dir)
	if len(a:dir) == 0
		" Check for fzf.conf from PWD
		let path = getcwd()
		if filereadable(path . '/fzf.conf')
			for line in readfile(path . '/fzf.conf')
				if line =~ 'SEARCH_DIRS\s*='
					let dirs = substitute(line,
						\ 'SEARCH_DIRS\s*=\s*', '', 'g')
				endif
			endfor
		else
			let dirs = '.'
		endif
		if executable('fd')
			" Use fd as the find executable
			let exec='fd'
		elseif executable('fdfind')
			let exec='fdfind'
		else
			echo 'Error, fdfind is not installed'
			return 1
		endif
		" Now launch fdfind with list of directories
		call fzf#run(fzf#wrap(fzf#vim#with_preview(
			\ {'source': exec.' --no-ignore . '.dirs, 'sink': 'e'})))
	else
		" If directory is provided, use it and skip fzf.conf
		let directory = a:dir
		let path = expand(directory)
		if !isdirectory(path)
			echo "Directory not found: ".path
			" Error here, don't launch FZF find window
			return 1
		endif
		" Call FZF files directly
		call fzf#vim#files(directory, fzf#vim#with_preview())
	endif
endfunction

" Replace standard Files command to instead launch our Files function
command! -complete=dir -nargs=* Files call SmartFiles(<q-args>)

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
	let cmd = 'git -C ' . file_dir . ' rev-parse --abbrev-ref HEAD'
	let git_head = trim(system(cmd))
	if git_head =='main' || git_head == 'master'
		" Get the SHA of the actual commit, so the link stays valid
		let cmd = 'git -C ' . file_dir . ' rev-parse HEAD'
		let git_head = trim(system(cmd))
	else
		" Abuse a feature of the github API- using master as branch name
		" always seems to redirect us to default branch
		let git_head = 'master'
	endif
	let url = remote . '/blob/' . git_head . '/' . git_file . '#L' . linenum
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

" Set colorscheme to gruvbox
colorscheme gruvbox

" Set SpellBad highlighting to underline
hi SpellBad cterm=underline

" Use terminal gui colors
set termguicolors

" 80 column indicator
set colorcolumn=80

" numbering
set number

" set gui font to one with powerline glyphs
set guifont=CaskaydiaCove\ Nerd\ Font\ Mono

" Map .overlay files to the dts file type
autocmd BufRead,BufNewFile *.overlay set filetype=dts
