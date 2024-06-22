local function GetGitRoot()
  local current_dir = vim.fn.expand('%:p:h')
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(current_dir) .. ' rev-parse --show-toplevel')[1]
  return git_root
end

local function GetFileRelativeToRoot()
  local current_file = vim.fn.expand('%:p')
  local git_root = GetGitRoot()
  if git_root == '' then
    return current_file
  end
  return current_file:gsub(git_root, '')
end

local function runPytest()
  -- Find the "service" name from the nearest devcontainer.json file
  local devcontainer = require('devcontainer.config_file.parse').parse_nearest_devcontainer_config()
  -- Find the current file relative to the root of the git repository
  local current_file = GetFileRelativeToRoot()

  require('devcontainer.container').exec(
  -- TODO: Add support for customizing which container to run
    devcontainer and devcontainer.service or 'service',
    {
      command = { 'pytest', current_file },
      tty = true,
    }
  )
end

return {
  {
    'https://codeberg.org/esensar/nvim-dev-container',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('devcontainer').setup({
        attach_mounts = {
          neovim_config = {
            enabled = true,
            options = { "read_only" }
          },
          neovim_data = {
            enabled = true,
            options = {}
          },
        }
      })
    end,
    keys = {
      {
        '<leader>tf', runPytest, desc = "Test file", ft = { 'python' }
      }
    }
  }
}
