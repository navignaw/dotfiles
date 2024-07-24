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
  -- TODO: Add support for customizing which container to run
  local devcontainer = require("devcontainer.config_file.parse").parse_nearest_devcontainer_config()
  local service = devcontainer and devcontainer.service or "devcontainer"
  -- Find the current file relative to the root of the git repository
  local current_file = get_file_relative_to_root()

  local args = {}
  if nearest then
    local nearest_test_name = nearest_test()
    if nearest_test_name ~= "" then
      args = { "-k " .. nearest_test_name }
    end
  end

  require("devcontainer.container").exec(service, {
    command = { "pytest", current_file, unpack(args) },
    tty = true,
  })
end

local function run_bazel(command)
  command = command or "build"
  -- Find the "service" name from the nearest devcontainer.json file
  -- TODO: Add support for customizing which container to run
  local devcontainer = require("devcontainer.config_file.parse").parse_nearest_devcontainer_config()
  local service = devcontainer and devcontainer.service or "devcontainer"
  local nearest_bazel_dir = utils.get_nearest_bazel_dir()
  local commands = { "bazel", "query" }
  if command == "test" then
    table.insert(commands, "kind('test rule', /" .. nearest_bazel_dir .. "/...)")
  else
    table.insert(commands, "/" .. nearest_bazel_dir .. "/...")
  end

  local container = require("devcontainer.container")
  container.exec(service, {
    command = commands,
    capture_output = true,
    on_success = function(output)
      local lines = vim.split(output or "", "\n", { trimempty = true })
      if #lines == 0 then
        vim.notify("No targets found")
        return
      end

      local run_command = function(targets)
        vim.notify("Running bazel " .. command .. ": " .. table.concat(targets, " "))
        container.exec(service, {
          command = { "bazel", command, unpack(targets) },
          tty = true,
        })
      end

      if #lines == 1 then
        run_command(lines)
        return
      end

      -- Choose test targets to run via telescope
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local sorters = require("telescope.sorters")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      pickers
        .new({
          prompt_title = "Bazel targets",
          finder = finders.new_table({
            results = lines,
          }),
          sorter = sorters.get_generic_fuzzy_sorter({}),
          attach_mappings = function()
            actions.select_default:replace(function()
              local targets = action_state.get_selected_entry()
              run_command(targets)
            end)
            return true
          end,
        }, {})
        :find()
    end,
  })
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
      { "<leader>bb", run_bazel, desc = "Bazel build" },
      {
        "<leader>br",
        function()
          run_bazel("run")
        end,
        desc = "Bazel run",
      },
      {
        "<leader>tb",
        function()
          run_bazel("test")
        end,
        desc = "Bazel tests",
      },
    },
  },
}
