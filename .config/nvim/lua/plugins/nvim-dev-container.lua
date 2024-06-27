local utils = require("utils")

local function get_file_relative_to_root()
  local current_file = vim.fn.expand("%:p")
  local git_root = utils.get_git_root()
  if git_root == "" then
    return current_file
  end
  return current_file:gsub(git_root, "")
end

local function nearest_test()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return ""
  end
  --@type ts_utils.TSNode?
  local expr = current_node
  while expr do
    if expr:type() == "function_definition" then
      break
    end
    expr = expr:parent()
  end
  if not expr then
    return ""
  end
  return ts_utils.get_node_text(expr:child(1))[1]
  --return (vim.treesitter.get_node_text(expr:child(1)))[1]
end

local function run_pytest(nearest)
  -- Find the "service" name from the nearest devcontainer.json file
  local devcontainer = require("devcontainer.config_file.parse").parse_nearest_devcontainer_config()
  -- Find the current file relative to the root of the git repository
  local current_file = get_file_relative_to_root()

  local args = {}
  if nearest then
    local nearest_test_name = nearest_test()
    if nearest_test_name ~= "" then
      args = { "-k " .. nearest_test_name }
    end
  end

  require("devcontainer.container").exec(
  -- TODO: Add support for customizing which container to run
    devcontainer and devcontainer.service or "service",
    {
      command = { "pytest", current_file, unpack(args) },
      tty = true,
    }
  )
end

return {
  {
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("devcontainer").setup({
        attach_mounts = {
          neovim_config = {
            enabled = true,
            options = { "read_only" },
          },
          neovim_data = {
            enabled = true,
            options = {},
          },
        },
      })
    end,
    keys = {
      { "<leader>tf", run_pytest, desc = "Test file", ft = { "python" } },
      {
        "<leader>tn",
        function()
          run_pytest(true)
        end,
        desc = "Test nearest",
        ft = { "python" },
      },
    },
  },
}
