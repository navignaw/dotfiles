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

" Plugin Settings

" ----- tpope/vim-abolish settings -----
"(S)ubstitute all with vim-abolish
nnoremap <leader>s *:%S/<C-r><C-w>//g<left><left>

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

" ----- vim-test settings -----
"nmap <silent> <Leader>t :TestNearest<CR>
"nmap <silent> <Leader>tf :TestFile<CR>
"nmap <silent> <Leader>ta :TestSuite<CR>
"nmap <silent> <Leader>tl :TestLast<CR>
"nmap <silent> <Leader>tg :TestVisit<CR>

"let test#strategy = "neovim"
"let g:test#neovim#start_normal = 1
"let g:test#javascript#runner = 'jest'
"let g:test#javascript#jest#file_pattern = '\v(__tests__/)?.*\.test(\.web|native)?\.(j|t)sx?$'

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

" ----- neo-tree settings -----
nnoremap \ :Neotree toggle current reveal_force_cwd<cr>
nnoremap <Bar> :Neotree reveal<cr>
nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>

]])
