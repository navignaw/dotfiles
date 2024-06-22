-- Syntax highlighting

local configs = {
  'bash',
  'css',
  'dockerfile',
  'go',
  'html',
  'javascript',
  'json',
  'jsonc',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'ruby',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  { 'yasuhiroki/github-actions-yaml.vim' },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = configs,
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
}
