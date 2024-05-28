return {
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
}
