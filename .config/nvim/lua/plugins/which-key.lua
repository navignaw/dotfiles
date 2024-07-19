return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      notify = false,
      triggers_blacklist = {
        n = { "q", "Q", ";" },
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
  },
}
