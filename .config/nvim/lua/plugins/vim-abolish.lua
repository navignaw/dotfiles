-- Shortcuts

return {
  {
    "tpope/vim-abolish",
    keys = {
      { "<leader>s", "*:%S/<C-r><C-w>//g<left><left>", desc = "Substitute current word" },
    },
  },
}
