-- Syntax highlighting

local configs = {
  'python', 'lua', 'typescript', 'javascript', 'json', 'yaml', 'html', 'css', 'bash', 'dockerfile', 'go', 'ruby', 'vim',
  'markdown', 'markdown_inline', 'regex',
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
