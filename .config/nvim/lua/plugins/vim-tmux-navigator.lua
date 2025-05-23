-- Integration with tmux

return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local navigation = require("nvim-tmux-navigation")

      navigation.setup({})

      vim.keymap.set("n", "<M-h>", navigation.NvimTmuxNavigateLeft, { desc = "Navigate left (tmux)" })
      vim.keymap.set("n", "<M-j>", navigation.NvimTmuxNavigateDown, { desc = "Navigate down (tmux)" })
      vim.keymap.set("n", "<M-k>", navigation.NvimTmuxNavigateUp, { desc = "Navigate up (tmux)" })
      vim.keymap.set("n", "<M-l>", navigation.NvimTmuxNavigateRight, { desc = "Navigate right (tmux)" })
      vim.keymap.set("n", "<M-\\>", navigation.NvimTmuxNavigateLastActive, { desc = "Navigate last active (tmux)" })
      vim.keymap.set("n", "<M-Space>", navigation.NvimTmuxNavigateNext, { desc = "Navigate next (tmux)" })
    end,
  },
}
