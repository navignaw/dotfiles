local utils = require("utils")

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

local function run_bazel(command, additional_args)
  command = command or "build"
  -- Find the "service" name from the nearest devcontainer.json file
  local devcontainer = require("devcontainer.config_file.parse").parse_nearest_devcontainer_config()
  local service = devcontainer and devcontainer.service or "docker"
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
        if command == "test" then
          table.insert(targets, "--test_arg=--color=yes")
          table.insert(targets, "--experimental_ui_max_stdouterr_bytes=999999999")
        end
        if additional_args then
          table.insert(targets, "--test_arg=" .. additional_args)
        end
        container.exec(service, {
          command = { "bazel", command, unpack(targets) },
          tty = true,
        })
      end

      if #lines == 1 then
        run_command(lines)
        return
      end

      -- Choose test targets to run
      vim.ui.select(lines, {
        prompt = "Bazel targets",
      }, function(selected)
        run_command({ selected })
      end)
    end,
  })
end

local function run_bazel_pytest(nearest)
  local args
  if nearest then
    local nearest_test_name = nearest_test()
    if nearest_test_name ~= "" then
      args = "-k=" .. nearest_test_name
    else
      args = "-k=" .. vim.fn.expand("%:t")
    end
  else
    args = "-k=" .. vim.fn.expand("%:t") -- Grab test file
  end

  run_bazel("test", args)
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
        config_search_start = function()
          if not vim.g.devcontainer_selected_config then
            local candidates = vim.split(
              vim.fn.glob(vim.loop.cwd() .. "/.devcontainer/**/devcontainer.json"),
              "\n",
              { trimempty = true }
            )
            if #candidates < 2 then
              vim.g.devcontainer_selected_config = vim.loop.cwd()
            else
              local choices = { "Select devcontainer config file to use:" }
              for idx, candidate in ipairs(candidates) do
                table.insert(choices, idx .. ". - " .. candidate)
              end
              local choice_idx = vim.fn.inputlist(choices)
              if choice_idx > #candidates then
                choice_idx = 1
              end
              vim.g.devcontainer_selected_config = string.gsub(candidates[choice_idx], "/devcontainer.json", "")
            end
          end
          return vim.g.devcontainer_selected_config
        end,
      })
    end,
    keys = {
      {
        "<leader>tf",
        run_bazel_pytest,
        desc = "Test file",
        ft = { "python" },
      },
      {
        "<leader>tn",
        function()
          run_bazel_pytest(true)
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
