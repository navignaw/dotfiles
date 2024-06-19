-- Integration with tmux

return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local navigation = require('nvim-tmux-navigation')

      navigation.setup {}

      vim.keymap.set('n', "<M-h>", navigation.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<M-j>", navigation.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<M-k>", navigation.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<M-l>", navigation.NvimTmuxNavigateRight)
      -- Mac characters
      vim.keymap.set('n', "˙", navigation.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "∆", navigation.NvimTmuxNavigateDown)
      vim.keymap.set('n', "˚", navigation.NvimTmuxNavigateUp)
      vim.keymap.set('n', "¬", navigation.NvimTmuxNavigateRight)
      vim.keymap.set('n', "<M-\\>", navigation.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', "<M-Space>", navigation.NvimTmuxNavigateNext)
    end,
  }
}
