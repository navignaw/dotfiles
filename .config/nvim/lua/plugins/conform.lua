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
          javascript = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          javascriptreact = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          json = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          markdown = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          sh = { "shfmt" },
          typescript = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          typescriptreact = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          yaml = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
