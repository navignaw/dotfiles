-- Plugins, managed by lazy.nvim

-- Space as leader key: <Space-w>, <Space-q> to save and quit
vim.g.mapleader = ' '

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
          lualine_x = { 'searchcount', 'lsp_progress' },
          lualine_y = { 'filetype' },
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
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'python', 'lua', 'typescript', 'javascript', 'json', 'yaml', 'html', 'css', 'bash', 'dockerfile', 'go', 'ruby', 'vim', 'markdown',
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
    },
    keys = {
      { '<C-p>',      '<cmd>Telescope git_files<CR>',            desc = 'Find files in git repo' },
      { '<C-f>',      '<cmd>Telescope live_grep<CR>',            mode = { 'n' },                         desc = 'Live grep' },
      { '<C-f>',      '<cmd>Telescope grep_string<CR>',          mode = { 'x' },                         desc = 'Grep highlighted string' },
      { '<leader>b',  '<cmd>Telescope buffers<CR>',              desc = 'Open buffers' },
      { '<leader>h',  '<cmd>Telescope help_tags<CR>',            desc = 'Help tags' },
      { '<leader>qf', '<cmd>Telescope quickfix<CR>',             desc = 'Quickfix list' },
      { '<leader>d',  '<cmd>Telescope lsp_definitions<CR>',      desc = 'Jump to definitions (LSP)' },
      { '<leader>r',  '<cmd>Telescope lsp_references<CR>',       desc = 'Jump to references (LSP)' },
      { '<leader>t',  '<cmd>Telescope lsp_type_definitions<CR>', desc = 'Jump to type definitions (LSP)' },
      { '<leader>gs', '<cmd>Telescope git_status<CR>',           desc = 'Git status' },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<C-d>'] = actions.delete_buffer + actions.move_to_top,
              }
            }
          },
          git_status = {
            mappings = {
              i = {
                ['<C-a>'] = actions.git_staging_toggle,
              }
            }
          },
        },
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-s>'] = actions.select_horizontal,
            },
          },
        },
      }
    end
  },
  {
    -- Setup telescope UI for select actions like "code_actions"
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          }
        },
      })
      telescope.load_extension("ui-select")
    end
  },

  -- Linters
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        root_dir = require('null-ls.utils').root_pattern('.git'),
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.diagnostics.buildifier,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.hover.printenv,
        },
      })
    end,
  },

  -- Formatters
  -- Even though none-ls supports formatters, this plugin does a better job of picking up prettier config
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          bazel = { 'buildifier' },
          lua = { 'stylua' },
          javascript = { { 'prettierd', 'prettier' } },
          javascriptreact = { { 'prettierd', 'prettier' } },
          json = { { 'prettierd', 'prettier' } },
          markdown = { { 'prettierd', 'prettier' } },
          sh = { 'shfmt' },
          typescript = { { 'prettierd', 'prettier' } },
          typescriptreact = { { 'prettierd', 'prettier' } },
          yaml = { { 'prettierd', 'prettier' } },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- LSP and installers
  { 'folke/neodev.nvim' },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      }
    },
    config = function()
      require("neodev").setup({}) -- set up neovim config for Lua LSP
      local lspconfig = require('lspconfig')
      local lsps = { 'eslint', 'lua_ls', 'pyright', 'ruff', 'tsserver' }
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
          map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        end,
      })
      local on_attach = function(client, bufnr)
        -- Highlight references when hovering over word
        if client.server_capabilities.documentHighlightProvider then
          local augroup = vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = augroup,
          })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.diagnostic.open_float() -- Show diagnostics in float window
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = augroup,
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

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, lsp in pairs(lsps) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },

  -- Auto-completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        event = 'BufReadPre',
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
      },
      {
        'windwp/nvim-autopairs',
        event = 'BufReadPre',
        config = true,
        opts = {
          map_cr = true,
        }
      },
      {
        'zbirenbaum/copilot.lua',
        event = 'InsertEnter',
        config = function()
          require('copilot').setup({
            suggestion = {
              auto_trigger = true,
            }
          })
        end,
      },

      'onsails/lspkind-nvim',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    event = 'BufReadPre',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          expandable_indicator = true,
          fields = { cmp.ItemField.Abbr, cmp.ItemField.Kind },
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          -- Integrated mappings for luasnip and cmp
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            local copilot = require('copilot.suggestion')
            if copilot.is_visible() then
              if cmp.visible() and cmp.get_selected_entry() then
                -- If completion menu is open, select previous item
                cmp.select_prev_item()
              else
                copilot.accept()
              end
            elseif cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        })
      })
      -- Compatibility with autopairs
      cmp.event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
      )
    end,
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
