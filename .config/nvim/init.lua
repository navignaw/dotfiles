-- Space as leader key: <Space-w>, <Space-q> to save and quit
-- Needs to be set before any plugins are loaded
vim.g.mapleader = ' '

require('lazy_plugins')
require('settings')
require('mappings')
require('commands')
