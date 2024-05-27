HOME = os.getenv("HOME")

-- Display
vim.opt.number = true
vim.opt.showmode = false
vim.opt.colorcolumn = '80'
vim.opt.updatetime = 300
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.cmdheight = 2

-- Highlight trailing whitespace, tabs, and funny characters
vim.opt.list = true
vim.opt.listchars = { nbsp = '¬', tab = '»·', trail = '·' }

-- Remove error bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Searching
vim.opt.ignorecase = true
vim.opt.showmatch = true
vim.opt.shortmess = 'filnxtToOFc'

-- Ignore tmp dirs, binary images, compiled bytecode
vim.opt.wildignore = [[
  */tmp/*,*/vendor/*,*.git/*,
  *.aux,*.out,*.toc,
  *.jpg,*.jpeg,*.bmp,*.gif,*.png,*.pdf,
  *.o,*.obj,*.exe,*.dll,*.manifest,
  *.so,*.swp,*.zip,*.pyc
]]

-- Tabs
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Misc
vim.opt.autoread = true
vim.opt.lazyredraw = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.so = 8
--vim.opt.pastetoggle = '<F2>'

-- Language-specific settings
vim.g.python_indent = {
  open_paren = 'shiftwidth() * 1',
  nested_paren = 'shiftwidth() * 1',
  continue = 'shiftwidth() * 1',
  closed_paren_align_last_line = 'v:false',
  disable_parentheses_indenting = 'v:false',
  searchpair_timeout = 150
}
