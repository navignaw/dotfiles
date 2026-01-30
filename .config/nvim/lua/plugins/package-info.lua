return {
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("package-info").setup({
        highlights = {
          up_to_date = { fg = "#3c4048" }, -- Text color for up to date dependency virtual text
          outdated = { fg = "#d19a66" }, -- Text color for outdated dependency virtual text
        },
        package_manager = "yarn",
      })

      local wk = require("which-key")
      wk.add({
        { "<leader>pi", group = "Package Info" },
        {
          "<leader>pid",
          function()
            require("package-info").delete()
          end,
          desc = "Delete package",
        },
        {
          "<leader>pii",
          function()
            require("package-info").install()
          end,
          desc = "Install package",
        },
        {
          "<leader>pit",
          function()
            require("package-info").toggle()
          end,
          desc = "Toggle package info",
        },
        {
          "<leader>piu",
          function()
            require("package-info").update()
          end,
          desc = "Update package",
        },
        {
          "<leader>piv",
          function()
            require("package-info").change_version()
          end,
          desc = "Change package version",
        },
      })
    end,
  },
}
