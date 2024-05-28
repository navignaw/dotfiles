-- Fuzzy finder
local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

local function find_files_frecency()
  require('telescope').extensions.frecency.frecency {
    prompt_title = 'Find files',
    workspace = 'CWD',
  }
end

local function live_grep_from_project_git_root()
  local opts = {}

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require('telescope.builtin').live_grep(opts)
end

local function edit_neovim()
  local opts = {
    prompt_title = 'Neovim Config',
    cwd = vim.fn.stdpath('config'),
  }

  require('telescope.builtin').find_files(opts)
end

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<C-p>',      find_files_frecency,                       desc = 'Find files by frecency' },
      { '<C-f>',      live_grep_from_project_git_root,           mode = { 'n' },                         desc = 'Live grep' },
      { '<C-f>',      '<cmd>Telescope grep_string<CR>',          mode = { 'x' },                         desc = 'Grep highlighted string' },
      { '<leader>b',  '<cmd>Telescope buffers<CR>',              desc = 'Open buffers' },
      { '<leader>ev', edit_neovim,                               desc = 'Edit neovim' },
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

  -- native telescope sorter to significantly improve sorting performance
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "make",
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
      telescope.load_extension('ui-select')
    end
  },

  -- "frecency" algorithm to rank more common search results
  {
    'nvim-telescope/telescope-frecency.nvim',
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        extensions = {
          frecency = {
            matcher = 'fuzzy',
            db_safe_mode = false,
            workspaces = {
              ['conf'] = vim.fn.stdpath('config'),
              ['app'] = 'frontend/ordering-app/',
              ['cb'] = 'services/customer-backend/',
              ['ns'] = 'services/nest-service/',
              ['zms'] = 'services/zipline_manager_service/',
            },
          },
        },
      })
      telescope.load_extension('frecency')
    end,
  },
}
