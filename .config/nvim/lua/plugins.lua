-- Plugins, managed by lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
      }
      require('onedark').load()
    end
  },

  -- Git configuration
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('gitsigns').setup {}
    end,
    on_attach = function(client)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk)
      map('n', '<leader>hr', gitsigns.reset_hunk)
      map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      map('n', '<leader>hS', gitsigns.stage_buffer)
      map('n', '<leader>hu', gitsigns.undo_stage_hunk)
      map('n', '<leader>hR', gitsigns.reset_buffer)
      map('n', '<leader>hp', gitsigns.preview_hunk)
      map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
      map('n', '<leader>hd', gitsigns.diffthis)
      map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
      map('n', '<leader>td', gitsigns.toggle_deleted)

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  },
  'tpope/vim-fugitive',
  'rhysd/conflict-marker.vim',

  -- Shortcuts
  'tpope/vim-abolish',

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      dependencies = { 'nvim-tree/nvim-web-devicons' }
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
        },
        sections = {
          lualine_a = { 'mode', 'vim.o.paste and "PASTE" or ""' },
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'searchcount'},
          lualine_z = {}
        }
      }
    end
  },

  -- Navigation
  'christoomey/vim-tmux-navigator',

  -- Syntax highlighting
  -- {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},

  -- LSP
  -- { 'neovim/nvim-lspconfig' },
  'dense-analysis/ale',
  'neoclide/coc.nvim', --{'branch': 'release'},
  'leafgarland/typescript-vim',
  'peitalin/vim-jsx-typescript',
  'yasuhiroki/github-actions-yaml.vim',
  'hankei6km/ale-linter-actionlint.vim',
  'junegunn/fzf', --{ 'do': { -> fzf#install() } },
  'antoinemadec/coc-fzf',

  -- Auto-completion
  'honza/vim-snippets',
  'github/copilot.vim',
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
      map_cr = true,
    }
    -- this is equalent to setup({}) function
  },

  -- Formatting
  { 'google/vim-codefmt',
    enabled = working,
    dependencies = {
      'google/vim-maktaba',
      {'google/vim-glaive', config = function() vim.cmd('call glaive#Install()') end}
    },
  },

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup {
        filesystem = {
          filtered_items = {
            hide_dotfiles = false
          },
        },
      }
    end
  },

  -- Testing
  'vim-test/vim-test',
  'mfussenegger/nvim-dap',
  'nvim-neotest/nvim-nio',
  'rcarriga/nvim-dap-ui',
  'mxsdev/nvim-dap-vscode-js',
})
