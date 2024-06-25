local M = {}

M.get_git_root = function()
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel")[1]
  return git_root
end

return M
