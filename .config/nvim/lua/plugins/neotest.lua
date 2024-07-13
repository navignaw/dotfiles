-- Testing plugins

local function getJestConfigFile(file)
  if string.find(file, "/frontend/") then
    -- Traverse up the file tree until we find a jest.config.ts
    return file:match("(.-/frontend/[^/]+)") .. "jest.config.ts"
  end

  return vim.fn.getcwd() .. "/jest.config.ts"
end

local function getFrontendRoot(file)
  if string.find(file, "/frontend/") then
    return file:match("(.-/frontend/[^/]+)")
  end

  return vim.fn.getcwd()
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/neodev.nvim",
      -- Language plugins
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neodev").setup({
        library = { plugins = { "neotest" }, types = true },
      })
      local jest_adapter = require("neotest-jest")({
        jestCommand = "yarn jest",
        jestConfigFile = getJestConfigFile,
        cwd = getFrontendRoot,
        strategy_config = function(default_strategy, _)
          default_strategy["resolveSourceMapLocations"] = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          }
          return default_strategy
        end,
      })
      -- Override jest adapter's is_test_file to include native or web tests
      local jt_is_test_file = jest_adapter.is_test_file
      jest_adapter.is_test_file = function(file)
        return jt_is_test_file(file)
          or string.match(file, "%.test%.native%.ts(x?)$")
          or string.match(file, "%.test%.web%.ts(x?)$")
      end

      require("neotest").setup({
        adapters = {
          jest_adapter,
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
        status = { enabled = true, virtual_text = true },
        output = { enabled = true, open_on_run = true },
      })
    end,
    keys = {
      {
        "<leader>tn",
        function()
          local neotest = require("neotest")
          neotest.run.run()
          neotest.output.open({
            open_win = function()
              vim.cmd("vsplit")
            end,
          })
        end,
        desc = "Test nearest",
      },
      {
        "<leader>tf",
        function()
          local neotest = require("neotest")
          neotest.run.run(vim.fn.expand("%"))
          neotest.output.open({
            open_win = function()
              vim.cmd("vsplit")
            end,
          })
        end,
        desc = "Test file",
        -- NOTE: pytest is currently set up in nvim-dev-container to run inside docker.
        ft = { "javascript", "typescript", "typescriptreact" },
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Open test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<silent>[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Jump to next failed test",
      },
      {
        "<silent>]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Jump to next failed test",
      },

      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Test nearest (debug)",
        -- TODO: Debug DAP for python
        ft = { "javascript", "typescript", "typescriptreact" },
      },
    },
  },
}
