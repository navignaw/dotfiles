return {
  {
    -- jsonnet syntax highlighting
    "google/vim-jsonnet",
    config = function()
      vim.g.jsonnet_fmt_on_save = 1
    end,
  },
}
