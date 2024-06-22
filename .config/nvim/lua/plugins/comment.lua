return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup({
        -- Normal mode
        toggler = {
          line = '<leader>cc',  -- Line-comment toggle keymap
          block = '<leader>cb', -- Block-comment toggle keymap
        },
        -- Visual mode
        opleader = {
          line = '<leader>c',   -- Line-comment keymap
          block = '<leader>cb', -- Block-comment keymap
        },
        extra = {
          above = '<leader>cO', -- Add comment on the line above
          below = '<leader>co', -- Add comment on the line below
          eol = '<leader>cA',   -- Add comment at the end of line
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  }
}
