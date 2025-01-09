local M = {}

M.is_git_repo = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

M.get_git_root = function()
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel")[1]
  return git_root
end

M.get_nearest_bazel_dir = function()
  -- Walk up the directory tree until we find a BUILD.bazel file
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = M.get_git_root()
  while current_dir ~= git_root do
    if vim.fn.filereadable(current_dir .. "/BUILD.bazel") == 1 then
      break
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  -- Return path relative to git root
  return current_dir:gsub(git_root, "")
end

M.get_visual_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

return M
