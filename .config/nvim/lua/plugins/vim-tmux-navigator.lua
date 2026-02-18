-- Integration with tmux

return {
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      {
        "<M-h>",
        "<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<CR>",
        desc = "Tmux Left",
        mode = { "n", "v", "i", "t" },
      },
      {
        "<M-j>",
        "<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<CR>",
        desc = "Tmux Down",
        mode = { "n", "v", "i", "t" },
      },
      {
        "<M-k>",
        "<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<CR>",
        desc = "Tmux Up",
        mode = { "n", "v", "i", "t" },
      },
      {
        "<M-l>",
        "<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<CR>",
        desc = "Tmux Right",
        mode = { "n", "v", "i", "t" },
      },
    },
    config = true,
  },
}
