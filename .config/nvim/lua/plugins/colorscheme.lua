-- Colorscheme

return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        highlights = {
          -- Mute the Folded highlight group
          ["Folded"] = { fg = "$light_grey" },
        },
      })
      require("onedark").load()
    end,
  },
}
