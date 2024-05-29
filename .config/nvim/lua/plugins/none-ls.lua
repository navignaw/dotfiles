-- Linters

return {
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
        should_attach = function(bufnr)
          -- Don't run on files matching yarn.loc
          return not vim.api.nvim_buf_get_name(bufnr):match('yarn.lock')
        end,
      })
    end,
  },
}
