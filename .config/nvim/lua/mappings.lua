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

local function show_filename()
  -- Show full path to file
  local filename = vim.fn.expand("%:p")
  vim.notify(filename)
end

imap("jk", "<Esc>") -- Exit insert mode
nmap("<C-l>", ":nohl<CR><C-l>") -- Remove highlighting
nmap("j", "gj") -- Move down visual line
nmap("k", "gk") -- Move up visual line
nmap(";", ":") -- Enter command mode
nmap("<C-g>", show_filename) -- Show filename

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
wk.add({
  { "<leader>bc", "<cmd>%bd|e#<CR>", desc = "Close all buffers except current" },
  { "<leader>cd", open_current_directory, desc = "Open directory of the current file" },
  { "<leader>g", group = "Git" },
  { "<leader>gl", git_link_file, desc = "Open Github link to the current line" },
  { "<leader>q", "<cmd>bd<CR>", desc = "Close buffer" },
  { "<leader>qa", "<cmd>q<CR>", desc = "Close all buffers" },
  { "<leader>up", "<cmd>!revup upload<CR>", desc = "Upload to revup" },
  { "<leader>vs", "<cmd>so ~/.config/nvim/init.lua<CR>", desc = "Source neovim" },
  { "<leader>w", "<cmd>w<CR>", desc = "Save" },
})
