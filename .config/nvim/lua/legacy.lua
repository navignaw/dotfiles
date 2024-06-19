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

" ----- neo-tree settings -----
nnoremap \ :Neotree toggle current reveal_force_cwd<cr>
nnoremap <Bar> :Neotree reveal<cr>
nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>

]])
