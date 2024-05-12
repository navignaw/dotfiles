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
Plug 'dense-analysis/ale'
Plug 'Raimondi/delimitMate'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'github/copilot.vim'
Plug 'yasuhiroki/github-actions-yaml.vim'
Plug 'hankei6km/ale-linter-actionlint.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'antoinemadec/coc-fzf'

Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'

Plug 'vim-test/vim-test'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mxsdev/nvim-dap-vscode-js'

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
set noswapfile
set so=8
set backspace=indent,eol,start
set pastetoggle=<F2>

" Language specific settings
au FileType python set colorcolumn=89          " ruff line limit at 88 chars
au FileType python set tabstop=4 shiftwidth=4  " indent 4 spaces

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
" Clear all buffers except current
nnoremap <Leader>bc :%bd\|e#<CR>
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

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

" Copy paste from system clipboard (Mac-specific)
vnoremap \y y:call system("pbcopy", getreg("\""))<CR>
nnoremap \p :call setreg("\"", system("pbpaste"))<CR>p
noremap YY "+y<CR>

" Custom functions

function! OpenCurrentDirectory()
  let l:current_dir = expand('%:p:h')
  silent execute 'edit ' . l:current_dir
endfunction
nnoremap <leader>cd :call OpenCurrentDirectory()<CR>

function! GetGitRoot()
  return systemlist('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --show-toplevel')[0]
endfunction

function! GitLinkFile()
  let l:current_file = expand('%:p')
  let l:current_line = line('.')
  let l:git_root = GetGitRoot()
  let l:git_file = substitute(l:current_file, l:git_root . '/', '', '')
  call system('git link ' . l:git_file . '#' . l:current_line)
endfunction
nnoremap <leader>gl :call GitLinkFile()<CR>

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

" ----- antoinemadec/coc-fzf settings -----
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []

" ----- vim-test settings -----
nmap <silent> <Leader>t :TestNearest<CR>
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ta :TestSuite<CR>
nmap <silent> <Leader>tl :TestLast<CR>
nmap <silent> <Leader>tg :TestVisit<CR>

let test#strategy = "neovim"
let g:test#neovim#start_normal = 1
let g:test#javascript#runner = 'jest'
let g:test#javascript#jest#file_pattern = '\v(__tests__/)?.*\.test(\.web|native)?\.(j|t)sx?$'

function! JestTestPath()
  let l:current_dir = expand('%:p:h')
  let l:jest_config = ''
  while l:current_dir !=# '/'
    let l:jest_config_ts = l:current_dir . '/jest.config.ts'
    let l:jest_config_js = l:current_dir . '/jest.config.js'
    if filereadable(l:jest_config_ts)
      let l:jest_config = l:jest_config_ts
      break
    elseif filereadable(l:jest_config_js)
      let l:jest_config = l:jest_config_js
      break
    endif
    let l:current_dir = fnamemodify(l:current_dir, ':h')
  endwhile

  return l:current_dir
  endfunction

let test#project_root = function('JestTestPath')

" ----- fzf-preview settings -----
let g:fzf_preview_command = 'bat --color=always --plain {-1}'
let g:fzf_preview_lines_command = 'bat --color=always --plain --number'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never --hidden'

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" ----- neo-tree settings -----
nnoremap \ :Neotree toggle current reveal_force_cwd<cr>
nnoremap <Bar> :Neotree reveal<cr>
nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>
nnoremap <leader>b :Neotree toggle show buffers right<cr>
"nnoremap <leader>gs :Neotree float git_status<cr>

nnoremap <silent> <C-p>        :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <Leader>gs   :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Leader>ga   :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap          <Leader>rg   :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          <Leader>rg   "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> <Leader>b    :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
