HOME = os.getenv("HOME")

-- Display
hidden = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.colorcolumn = '80'
vim.opt.background = 'dark'
vim.opt.updatetime = 300
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- Highlight trailing whitespace, tabs, and funny characters
vim.opt.list = true
vim.opt.listchars = { nbsp = '¬',tab = '»·', trail = '·' }

-- Remove error bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Searching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.wildmenu = true
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
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Misc
vim.opt.autoread = true
vim.opt.lazyredraw = true
vim.opt.laststatus = 2
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.so = 8
vim.opt.backspace = indent,eol,start
vim.opt.pastetoggle = '<F2>'
