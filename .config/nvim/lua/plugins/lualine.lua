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
          -- Don't show lualine when focused on DAP UI windows
          ignore_focus = {
            "dapui_watches",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dapui_stacks",
            "dap-repl",
          },
        },
        sections = {
          lualine_a = { "mode", 'vim.o.paste and "PASTE" or ""' },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = {
            "searchcount",
            "lsp_progress",
            {
              -- Show DAP status
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
          },
          lualine_y = { "filetype" },
          lualine_z = {},
        },
      })
    end,
  },
}
