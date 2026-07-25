-- Navigate Neovim splits, then fall through to the containing Herdr pane.

local M = {}

local directions = {
  h = "left",
  j = "down",
  k = "up",
  l = "right",
}

local function focus_herdr(direction)
  if vim.fn.executable("herdr") == 0 then
    return
  end

  vim.fn.system({ "herdr", "pane", "focus", "--direction", direction })
end

function M.navigate(key)
  local current_window = vim.api.nvim_get_current_win()
  local ok = pcall(vim.cmd, "wincmd " .. key)

  if ok and vim.api.nvim_get_current_win() ~= current_window then
    return
  end

  focus_herdr(directions[key])
end

function M.setup()
  for key in pairs(directions) do
    vim.keymap.set({ "n", "v", "i", "t" }, "<M-" .. key .. ">", function()
      M.navigate(key)
    end, { noremap = true, silent = true, desc = "Navigate " .. directions[key] })
  end
end

return M
