" Plugins (vim-bundle)
set nocp
filetype off
call plug#begin('~/.dotfiles/vim/bundle')

" Plugins
Plug 'joshdick/onedark.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/indentpython.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'github/copilot.vim'
Plug 'yasuhiroki/github-actions-yaml.vim'
Plug 'hankei6km/ale-linter-actionlint.vim'

call plug#end()

" Display
set hidden
set number
set showcmd
set noshowmode
set t_Co=256
set colorcolumn=81
set background=dark
set updatetime=300

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
set shortmess+=c

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

" Misc
set autoread
set lazyredraw
set laststatus=2
set nobackup
set nowritebackup
set nowb
set noswapfile
set so=8
set backspace=indent,eol,start
set pastetoggle=<F2>

" Colors
syntax on
let g:onedark_color_overrides = {
\   "black": {"gui": "#1c1c1c", "cterm": "234", "cterm16": "0" }
\}

colorscheme onedark
highlight ColorColumn ctermbg=8

" Mappings
" Space as leader key: <Space-w>, <Space-q> to save and quit
" <Space-d> to jump to definition
" <Space-r> to see references
" jk to exit insert mode
" <Ctrl-l> removes syntax highlighting
" <Ctrl-j>, <Ctrl-k> to switch buffers
let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <Leader>t <Plug>(coc-type-definition)
nnoremap <Leader>i <Plug>(coc-implementation)
nnoremap <Leader>r <Plug>(coc-references)

inoremap jk <Esc>
nnoremap <silent> <C-l> :nohl<CR><C-l>
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nmap <cr> i<cr>jk
map j gj
map k gk
nore ; :
nore , ;

" Edit and source vimrc!
nmap ,ev :e $MYVIMRC<bar>echo $MYVIMRC<cr>
nmap ,sv :so $MYVIMRC<bar>echo $MYVIMRC<cr>

" Plugin Settings

" ----- tpope/vim-abolish settings -----
"(S)ubstitute all with vim-abolish
nnoremap <leader>s *:%S/<C-r><C-w>//g<left><left>

" ----- bling/vim-airline settings -----
" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

let g:airline_section_y=''
let g:airline_skip_empty_sections = 1


" ----- dense-analysis/ale settings -----
" TODO: Replace these remaining linters with coc plugins
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '▲'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_linters = {
\   'yaml': ['actionlint', 'yamllint']
\}
let g:ale_fixers = {}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:airline#extensions#ale#enabled = 1

" Show errors in two lines.
set cmdheight=2

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1
nmap <silent> vd :GitGutterDiffOrig<cr>

" Ripgreg with Ctrlp
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" ----- coc and UltiSnips -----

" Tab and shift-tab navigate the completion list
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()

" Shift tab accepts Copilot by default, otherwise goes to the previous item
inoremap <expr><S-TAB>
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ----- christoomey/vim-tmux-navigator settings -----
let g:tmux_navigator_no_mappings = 1

" Fix alt-mapping.
for i in range(97,122)
  let c = nr2char(i)
  exec "map \e".c." <M-".c.">"
  exec "map! \e".c." <M-".c.">"
endfor

nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-;> :TmuxNavigatePrevious<cr>
" Mac characters
nnoremap <silent> ˙ :TmuxNavigateLeft<cr>
nnoremap <silent> ∆ :TmuxNavigateDown<cr>
nnoremap <silent> ˚ :TmuxNavigateUp<cr>
nnoremap <silent> ¬ :TmuxNavigateRight<cr>
nnoremap <silent> … :TmuxNavigatePrevious<cr>
