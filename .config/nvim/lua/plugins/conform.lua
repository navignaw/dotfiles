-- Formatters

return {
  -- Even though none-ls supports formatters, this plugin does a better job of picking up prettier config
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          bazel = { "buildifier" },
          lua = { "stylua" },
          javascript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          markdown = { { "prettierd", "prettier" } },
          sh = { "shfmt" },
          typescript = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          yaml = { { "prettierd", "prettier" } },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
