-- Debugging Adapter Protocol (DAP) plugins

local js_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

return {
  -- Debug Adapter Protocol client implementation for Neovim
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle({})
            end,
            desc = "Dap UI",
          },
          {
            "H",
            function()
              require("dapui").eval()
            end,
            desc = "Eval",
            mode = { "n", "v" },
          },
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
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          require("nvim-dap-virtual-text").setup({})
        end,
      },

      -- Automatically install debug adapters for nvim-dap
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "williamboman/mason.nvim",
        },
        config = function()
          require("mason-nvim-dap").setup({
            automatic_installation = false,
            ensure_installed = { "js", "python" },
          })
        end,
      },
    },
    config = function()
      local dap = require("dap")

      -- Set highlights and signs
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      -- Set up adapters
      for _, type in ipairs({ "chrome", "pwa-node", "pwa-chrome" }) do
        dap.adapters[type] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              vim.fn.resolve(
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
              ),
              "${port}",
            },
          },
        }
      end

      -- Set up configs
      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            -- Note: webRoot must be the root of the package, not the workspace.
            -- Consider automatically detecting this via package.json
            -- See: https://github.com/serranomorante/.dotfiles/blob/main/docs/nvim-dap-node-cli.md
            webRoot = vim.fn.getcwd(),
            sourceMaps = true,
          },

          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end
    end,
    keys = {
      {
        "<leader>da",
        function()
          if not vim.fn.filereadable(".vscode/launch.json") then
            vim.notify("No launch.json found", vim.log.levels.ERROR, { title = "DAP" })
          end
          require("dap").continue()
        end,
        desc = "Attach debugger",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Set Log Point",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to line (no execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
      {
        "<leader>dR",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Removes all breakpoints",
      },
    },
  },
}
