-- Legacy file containing remaining config in old ~/.vimrc.
-- TODO: migrate these to Lua syntax!

vim.cmd([[

" Custom functions

nnoremap <leader>up :!revup upload<CR>

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

" Custom function that runs CocCommand and grep from git root
"function! RgFromGitRoot()
  "let l:git_root = GetGitRoot()
  "call CocActionAsync('runCommand', 'fzf-preview.ProjectGrep', '"' . input('Search: ') . '"', l:git_root, '--add-fzf-arg="--delimiter=/"', '--add-fzf-arg="--with-nth -5.."')
"endfunction

" Plugin Settings

" ----- tpope/vim-abolish settings -----
"(S)ubstitute all with vim-abolish
nnoremap <leader>s *:%S/<C-r><C-w>//g<left><left>

" ----- coc and UltiSnips -----

" Tab and shift-tab navigate the completion list
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Shift tab accepts Copilot by default, otherwise goes to the previous item
inoremap <expr><S-TAB>
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

" ----- google/vim-codefmt settings -----
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
augroup END

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

" ----- neo-tree settings -----
nnoremap \ :Neotree toggle current reveal_force_cwd<cr>
nnoremap <Bar> :Neotree reveal<cr>
nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>
nnoremap <leader>b :Neotree toggle show buffers right<cr>
"nnoremap <leader>gs :Neotree float git_status<cr>

" Load preview on startup
nnoremap <silent> <C-p>        :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <Leader>gs   :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Leader>ga   :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap          <Leader>rg   :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
"nnoremap          <Leader>rg   :call RgFromGitRoot()<CR>
xnoremap          <Leader>rg   "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
"nnoremap <silent> <Leader>b    :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]c     :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
]])
