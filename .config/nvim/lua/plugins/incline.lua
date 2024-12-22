-- Show floating statuslines for different panes
return {
  {
    "b0o/incline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        ignore = {
          filetypes = { "sql" },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local modified_text = modified and "*" or ""
          return {
            ft_icon and {
              " ",
              modified_text,
              ft_icon,
              " ",
              guibg = ft_color,
              guifg = helpers.contrast_color(ft_color),
            } or modified_text,
            " ",

            { filename, gui = "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      })
    end,
    event = "VeryLazy",
  },
}
