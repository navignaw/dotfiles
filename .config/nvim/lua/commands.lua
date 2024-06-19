-- Autocommands

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "disable paste",
  group = init_group,
  pattern = "*",
  command = "if &paste | set nopaste | echo 'nopaste' | endif",
})
