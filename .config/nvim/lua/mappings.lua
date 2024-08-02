-- Mappings, using which-key

local utils = require("utils")

local function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map("n", shortcut, command)
end

local function imap(shortcut, command)
  map("i", shortcut, command)
end

local function vmap(shortcut, command)
  map("v", shortcut, command)
end

local function cmap(shortcut, command)
  map("c", shortcut, command)
end

imap("jk", "<Esc>")             -- Exit insert mode
nmap("<C-l>", ":nohl<CR><C-l>") -- Remove highlighting
nmap("j", "gj")                 -- Move down visual line
nmap("k", "gk")                 -- Move up visual line
nmap(";", ":")                  -- Enter command mode

-- Copy paste from system clipboard
vmap("YY", '"+y<CR>')

-- Shortcuts for commands
cmap("<C-a>", "<Home>")

--- Open directory of the current file
local function open_current_directory()
  local current_dir = vim.fn.expand("%:p:h")
  vim.cmd("silent edit " .. current_dir)
end

--- Open a Github link to the current line in the current file
local function git_link_file()
  local current_file = vim.fn.expand("%:p")
  local current_line = vim.fn.line(".")
  local git_root = utils.get_git_root()
  if git_root == "" then
    vim.notify("Not a git repository")
    return
  end
  local git_file = current_file:gsub(git_root .. "/", "")
  vim.fn.system("git link " .. git_file .. "#" .. current_line)
end

local wk = require("which-key")
wk.register({
  w = { "<cmd>w<CR>", "Save" },
  q = { "<cmd>bd<CR>", "Close buffer" },
  qa = { "<cmd>q<CR>", "Close all buffers" },
  bc = { "<cmd>%bd|e#<CR>", "Close all buffers except current" },
  vs = { "<cmd>so ~/.config/nvim/init.lua<CR>", "Source neovim" },
  up = { "<cmd>!revup upload<CR>", "Upload to revup" },
  cd = { open_current_directory, "Open directory of the current file" },
  g = {
    name = "Git",
    l = { git_link_file, "Open Github link to the current line" },
  },
}, { prefix = "<leader>" })
