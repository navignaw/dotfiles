return {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      -- Comment.nvim's pre_hook handles commentstring, so the CursorHold autocmd isn't needed
      { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
    },
    opts = function()
      return {
        -- Normal mode
        toggler = {
          line = "<leader>cc",  -- Line-comment toggle keymap
          block = "<leader>cb", -- Block-comment toggle keymap
        },
        -- Visual mode
        opleader = {
          line = "<leader>cc",  -- Line-comment keymap
          block = "<leader>cb", -- Block-comment keymap
        },
        extra = {
          above = "<leader>cO", -- Add comment on the line above
          below = "<leader>co", -- Add comment on the line below
          eol = "<leader>cA",   -- Add comment at the end of line
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
}
