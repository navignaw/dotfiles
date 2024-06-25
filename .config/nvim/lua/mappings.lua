-- Mappings

local function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

local function cmap(shortcut, command)
  map('c', shortcut, command)
end

local function tmap(shortcut, command)
  map('t', shortcut, command)
end

-- <Space-d> to jump to definition
-- <Space-r> to see references
-- jk to exit insert mode
-- <Ctrl-l> removes syntax highlighting
-- <Ctrl-j>, <Ctrl-k> to switch buffers

nmap('<Leader>w', ':w<CR>')
nmap('<Leader>q', ':bd<CR>')
nmap('<Leader>qa', ':q<CR>')

-- Clear all buffers except current
nmap('<Leader>bc', ':%bd|e#<CR>')

imap('jk', '<Esc>')
nmap('<C-l>', ':nohl<CR><C-l>')
nmap('<C-j>', ':bprev<CR>')
nmap('<C-k>', ':bnext<CR>')
nmap('<cr>', 'i<cr>')
nmap('j', 'gj')
nmap('k', 'gk')
nmap(';', ':')
nmap(',', ';')

-- Folds: toggle or open all folds recursively
nmap('<Leader>z', 'za')
nmap('<Leader>zo', 'zO')

-- Source neovim config
nmap('<Leader>sv', ':so ~/.config/nvim/init.lua<CR>')

-- Copy paste from system clipboard
vmap('YY', '"+y<CR>')

-- Shortcuts for commands
cmap('<C-a>', '<Home>')

-- Custom functions
nmap('<Leader>up', ':!revup upload<CR>')

-- Open directory of the current file
local function OpenCurrentDirectory()
  local current_dir = vim.fn.expand('%:p:h')
  vim.cmd('silent edit ' .. current_dir)
end
nmap('<Leader>cd', OpenCurrentDirectory)

local function GetGitRoot()
  local current_dir = vim.fn.expand('%:p:h')
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(current_dir) .. ' rev-parse --show-toplevel')[1]
  return git_root
end

-- Space + gl to open a Github link to the current line in the current file
local function GitLinkFile()
  local current_file = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')
  local git_root = GetGitRoot()
  if git_root == '' then
    print('Not a git repository')
    return
  end
  local git_file = current_file:gsub(git_root .. '/', '')
  vim.fn.system('git link ' .. git_file .. '#' .. current_line)
end

nmap('<Leader>gl', GitLinkFile)
