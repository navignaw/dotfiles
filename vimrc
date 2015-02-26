" Packages (vundle)
set nocp
filetype off
set rtp+=~/.dotfiles/vim/bundle/Vundle.vim/
let path='~/.dotfiles/vim/bundle'
call vundle#begin(path)

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'vim-scripts/a.vim'
Plugin 'Raimondi/delimitMate'

call vundle#end()
filetype plugin indent on

" Display
set number
set showcmd
set noshowmode
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

" Ignore tmp dirs, binary images, compiled bytecode
set wildignore+=*/tmp/*,*/vendor/*,*/\.git/*
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.pdf
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.so,*.swp,*.zip
set wildignore+=*.pyc

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
set laststatus=2
set nobackup
set nowb
set noswapfile
set so=8
set backspace=indent,eol,start
set pastetoggle=<F2>

colorscheme molokai
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

" Edit and source vimrc!
nmap ,ev :e $MYVIMRC<bar>echo $MYVIMRC<cr>
nmap ,sv :so $MYVIMRC<bar>echo $MYVIMRC<cr>

" Plugin Settings
" ----- bling/vim-airline settings -----
" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
" let g:airline#extensions#tabline#enabled = 1


" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END


" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1


" Ag with Ctrlp
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif


" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END
