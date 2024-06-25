-- Statusline
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress", -- Show LSP progress in statusbar
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "onedark",
        },
        sections = {
          lualine_a = { "mode", 'vim.o.paste and "PASTE" or ""' },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "searchcount", "lsp_progress" },
          lualine_y = { "filetype" },
          lualine_z = {},
        },
      })
    end,
  },
}
