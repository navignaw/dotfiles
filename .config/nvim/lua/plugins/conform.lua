-- Formatters

return {
  -- Even though none-ls supports formatters, this plugin does a better job of picking up prettier config
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "oxfmt" },
          javascriptreact = { "oxfmt" },
          json = { "oxfmt" },
          markdown = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          sh = { "shfmt" },
          typescript = { "oxfmt" },
          typescriptreact = { "oxfmt" },
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
