"syntax highlighting
filetype plugin indent on
syntax on

"80 column indicator
set colorcolumn=80

"five modelines
set modelines=5

"theme
colorscheme gruvbox

"numbering
set number

"enable powerline fonts for airline
let g:airline_powerline_fonts = 1

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
