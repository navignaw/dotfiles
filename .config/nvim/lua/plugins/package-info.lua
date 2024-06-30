return {
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3c4048", -- Text color for up to date dependency virtual text
          outdated = "#d19a66", -- Text color for outdated dependency virtual text
        },
        package_manager = "yarn",
      })

      local wk = require("which-key")
      wk.register({
        ["<leader>pi"] = {
          name = "Package Info",
          t = {
            function()
              require("package-info").toggle()
            end,
            "Toggle package info",
          },
          u = {
            function()
              require("package-info").update()
            end,
            "Update package",
          },
          d = {
            function()
              require("package-info").delete()
            end,
            "Delete package",
          },
          i = {
            function()
              require("package-info").install()
            end,
            "Install package",
          },
          v = {
            function()
              require("package-info").change_version()
            end,
            "Change package version",
          },
        },
      })
    end,
  },
}
