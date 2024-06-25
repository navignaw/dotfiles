-- File explorer

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "\\", "<cmd>Neotree toggle current reveal_force_cwd<CR>", desc = "Toggle file tree" },
      { "<Bar>", "<cmd>Neotree reveal<CR>", desc = "Reveal file tree" },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
          },
        },
      })
    end,
  },
}
