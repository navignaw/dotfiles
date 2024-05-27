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
      require('gitsigns').setup {
        on_attach = function(client, bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
          map('n', '<leader>td', gitsigns.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end,
  },
  'tpope/vim-fugitive',
  'rhysd/conflict-marker.vim',

  -- Shortcuts
  'tpope/vim-abolish',

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'arkav/lualine-lsp-progress', -- Show LSP progress in statusbar
    },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
        },
        sections = {
          lualine_a = { 'mode', 'vim.o.paste and "PASTE" or ""' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'filetype' },
          lualine_y = { 'searchcount', 'lsp_progress' },
          lualine_z = {}
        }
      }
    end
  },

  -- Syntax highlighting
  { 'yasuhiroki/github-actions-yaml.vim' },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      --local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      --parser_config.github_action = {
      --install_info = {
      --url = "https://github.com/rewinfrey/tree-sitter-github-action",
      --files = { "src/parser.c" },
      --location = "tree-sitter-github-action/yaml",
      --revision = "68ae5463fff054b7fc8037d36fce3a9e5ae2dfdc",
      --},
      --filetype = "yaml.gha",
      --maintainers = { "@rewinfrey" },
      --}
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'python', 'lua', 'typescript', 'javascript', 'json', 'yaml', 'html', 'css', 'bash', 'dockerfile', 'go', 'ruby', 'vim', 'markdown',
          --github_action
        },
        highlight = {
          enable = true,
          disable = { 'yaml.gha' }
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = true },
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      }
    end
  },

  -- Navigation
  { 'christoomey/vim-tmux-navigator' },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<C-p>',      '<cmd>Telescope git_files<CR>',            desc = 'Find files in git repo' },
      { '<leader>rg', '<cmd>Telescope live_grep<CR>',            mode = { 'n' },                         desc = 'Live grep' },
      { '<leader>rg', '<cmd>Telescope grep_string<CR>',          mode = { 'x' },                         desc = 'Grep highlighted string' },
      { '<leader>b',  '<cmd>Telescope buffers<CR>',              desc = 'Open buffers' },
      { '<leader>h',  '<cmd>Telescope help_tags<CR>',            desc = 'Help tags' },
      { '<leader>qf', '<cmd>Telescope quickfix<CR>',             desc = 'Quickfix list' },
      { '<leader>d',  '<cmd>Telescope lsp_definitions<CR>',      desc = 'Jump to definitions (LSP)' },
      { '<leader>r',  '<cmd>Telescope lsp_references<CR>',       desc = 'Jump to references (LSP)' },
      { '<leader>t',  '<cmd>Telescope lsp_type_definitions<CR>', desc = 'Jump to type definitions (LSP)' },
      { '<leader>gs', '<cmd>Telescope git_status<CR>',           desc = 'Git status' },
    },
    config = function()
      local actions = require("telescope.actions")
      require('telescope').setup {
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
              }
            }
          },
          git_status = {
            mappings = {
              i = {
                ["<C-a>"] = actions.git_staging_toggle,
              }
            }
          },
        },
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous,
              ["<C-s>"] = require('telescope.actions').select_horizontal,
            },
          },
        },
      }
    end
  },

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
          null_ls.builtins.diagnostics.buildifier,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.hover.printenv,
        },
        on_attach = function(client, bufnr)
          -- Format on save (formatters)
          local augroup = vim.api.nvim_create_augroup("NullLsAutoFormatting", {})
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
    config = function()
      local lspconfig = require('lspconfig')
      local lsps = { 'lua_ls', 'pyright', 'ruff', 'tsserver' }
      require('mason').setup({
        PATH = 'prepend'
      })
      require('mason-lspconfig').setup({
        ensure_installed = lsps
      })
      local map = function(type, key, value)
        vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true })
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function()
          map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
          map('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
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
        local augroup = vim.api.nvim_create_augroup('LspAutoFormatting', {})
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.lua', '*.py' },
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
