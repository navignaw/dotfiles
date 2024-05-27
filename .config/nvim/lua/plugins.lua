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
      --map('n', '<leader>hs', gitsigns.stage_hunk)
      --map('n', '<leader>hr', gitsigns.reset_hunk)
      --map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      --map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      --map('n', '<leader>hS', gitsigns.stage_buffer)
      --map('n', '<leader>hu', gitsigns.undo_stage_hunk)
      --map('n', '<leader>hR', gitsigns.reset_buffer)
      --map('n', '<leader>hp', gitsigns.preview_hunk)
      --map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
      --map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
      --map('n', '<leader>hd', gitsigns.diffthis)
      --map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
      --map('n', '<leader>td', gitsigns.toggle_deleted)

      -- Text object
      --map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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

  -- Linters and formatters
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.hover.printenv,
        },
        on_attach = function(client, bufnr)
          -- Format on save (formatters)
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
        end
        end
      })
    end,
  },

  -- LSP and installers
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      }
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local lsps = { 'pyright', 'ruff', 'tsserver' }
      require('mason').setup({
        PATH = 'prepend'
      })
      require('mason-lspconfig').setup({
        ensure_installed = lsps
      })
      local map = function(type, key, value)
        vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true})
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
          map('n', '<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
          map('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>')
          map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
          map('n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
          map('n', '<leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        end,
      })
      local on_attach = function(client)
        -- Highlight references when hovering over word
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
          })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Format on save (LSPs)
        local augroup = vim.api.nvim_create_augroup('AutoFormatting', {})
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*.py',
          group = augroup,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end

      for _, lsp in pairs(lsps) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
        })
      end
    end,
  },

  'leafgarland/typescript-vim',
  'peitalin/vim-jsx-typescript',
  'yasuhiroki/github-actions-yaml.vim',
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
