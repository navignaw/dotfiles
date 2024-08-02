-- Shortcuts for substitutions

return {
  {
    "tpope/vim-abolish",
    keys = {
      { "<leader>s", "*:%S/<C-r><C-w>//g<left><left>", desc = "Substitute current word" },
      {
        "<leader>s",
        -- Substitute current selection in visual mode by pasting into the h register
        '"zy:%S/<C-r>z//g<left><left>',
        mode = "v",
        desc = "Substitute current selection",
      },
    },
  },
}
