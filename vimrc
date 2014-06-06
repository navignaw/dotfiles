" Display
set number
set showcmd
set background=dark

" Syntax highlighting
set nocp
syntax on
filetype plugin indent on

" Remove error bells
set noerrorbells
set novisualbell

" Searching
set incsearch
set ignorecase
set hlsearch
set showmatch
set wildmenu

" Tabs
set expandtab
set smarttab
set autoindent
set tabstop=2 shiftwidth=2

" Misc
set autoread
set lazyredraw
set nobackup
set nowb
set noswapfile
set so=5

" Mappings
" jj to exit insert mode
" <Ctrl-l> removes syntax highlighting
" <Ctrl-j>, <Ctrl-k> to switch buffers
inoremap jj <Esc>
nnoremap <silent> <C-l> :nohl<CR><C-l>
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
map j gj
map k gk
nore ; :
nore , ;
