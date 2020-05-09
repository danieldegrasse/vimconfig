"syntax highlighting
filetype plugin indent on
syntax on

"80 column indicator
set colorcolumn=80


"theme
colorscheme gruvbox

"numbering
set number

"switch between tabs and spaces
" virtual tabstops using spaces
set shiftwidth=4
set softtabstop=4
set expandtab
" allow toggling between local and default mode
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

