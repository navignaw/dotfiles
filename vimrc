" Packages (vundle)
set nocp
filetype off
set rtp+=~/.dotfiles/vim/bundle/Vundle.vim/
let path='~/.dotfiles/vim/bundle'
call vundle#begin(path)

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

" Display
set number
set showcmd
set t_Co=256
set colorcolumn=81
set background=dark
syntax enable

" Highlight trailing whitespace, tabs, and funny characters
set list
set listchars=nbsp:¬,tab:»·,trail:·

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

" Tab completion
" insert tab at beginning of line; otherwise, tab complete
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Misc
set autoread
set lazyredraw
set nobackup
set nowb
set noswapfile
set so=5
set backspace=indent,eol,start
set pastetoggle=<F2>

colorscheme desert
highlight ColorColumn ctermbg=8

" Mappings
" jj to exit insert mode
" <Ctrl-l> removes syntax highlighting
" <Ctrl-j>, <Ctrl-k> to switch buffers
inoremap jj <Esc>
nnoremap <silent> <C-l> :nohl<CR><C-l>
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nmap <cr> i<cr><Esc>
map j gj
map k gk
nore ; :
nore , ;

" Plugin Settings
" Airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='zenburn'
let g:airline_enable_branch=1
