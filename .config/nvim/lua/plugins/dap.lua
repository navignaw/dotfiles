-- Testing and debugging

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

  -- Debug Adapter Protocol client implementation for Neovim
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
          { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",   mode = { "n", "v" }, },
        },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup({
            controls = {
              element = "repl",
              enabled = true,
              icons = {
                disconnect = " ",
                pause = " ",
                play = " ",
                run_last = " ",
                step_back = " ",
                step_into = " ",
                step_out = " ",
                step_over = " ",
                terminate = " ",
              },
            },
          })
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
        end,
      },

      -- An extension for nvim-dap, providing default configurations for python and methods to debug individual test methods or classes.
      -- Note: requires :MasonInstall debugpy
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          local adapter_python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          local dap_python = require("dap-python")
          dap_python.test_runner = "pytest"
          dap_python.setup(adapter_python_path)
        end,
      },

      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({})
        end,
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    end,
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                           desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                                    desc = "Continue" },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Set Log Point" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                               desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                       desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                                   desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                        desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                          desc = "Up" },
      { "<leader>do", function() require("dap").step_out() end,                                                    desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                                   desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                                       desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                                 desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                                     desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                                   desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                            desc = "Widgets" },
      { "<leader>dR", function() require("dap").clear_breakpoints() end,                                           desc = "Removes all breakpoints" },
    },
  },
  --{ 'mxsdev/nvim-dap-vscode-js' },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/neodev.nvim",
      -- Language plugins
      'nvim-neotest/neotest-jest',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require("neodev").setup({
        library = { plugins = { "neotest" }, types = true },
      })
      require("neotest").setup({
        adapters = {
          require('neotest-jest')({
            jestCommand = "yarn jest",
            jestConfigFile = getJestConfigFile,
            cwd = getFrontendRoot,
          }),
          require('neotest-python')({
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
          neotest.output.open({ open_win = function() vim.cmd("vsplit") end })
        end,
        desc = "Test nearest"
      },
      {
        "<leader>tf",
        function()
          local neotest = require("neotest")
          neotest.run.run(vim.fn.expand("%"))
          neotest.output.open({ open_win = function() vim.cmd("vsplit") end })
        end,
        desc = "Test file"
      },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                 desc = "Open test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end,            desc = "Toggle Output Panel" },
      { "<silent>[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Jump to next failed test" },
      { "<silent>]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Jump to next failed test" },

      -- TODO: Debug DAP for jest and python
      --{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test nearest (debug)" },
    },
  }
}
