-- Linters

return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        root_dir = require("null-ls.utils").root_pattern(".git"),
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.diagnostics.buildifier,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.yamllint,
          -- Note: most formatters are already handled by the LSP, e.g. ruff/prettier.
          -- Only include formatters that don't have an LSP equivalent.
          null_ls.builtins.formatting.buildifier,
          null_ls.builtins.hover.printenv,
        },
        should_attach = function(bufnr)
          -- Don't run on files matching yarn.lock
          return not vim.api.nvim_buf_get_name(bufnr):match("yarn.lock")
        end,
      })
    end,
  },
}
