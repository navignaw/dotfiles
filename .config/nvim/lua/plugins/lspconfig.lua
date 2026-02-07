-- LSP and installers

local lsps = {
  "buf_ls",
  "dockerls",
  "eslint",
  "gopls",
  "lua_ls",
  "ruff",
  "rust_analyzer",
  "starpls",
  "tailwindcss",
  "ts_ls",
  "ty",
}

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local function get_python_path(workspace)
  local util = require("lspconfig/util")

  local path = util.path

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ ".venv", "venv" }) do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      local newpath = path.join(path.dirname(match), "bin", "python")
      return newpath
    else
      vim.notify("No match found for venv" .. pattern .. " in " .. workspace, vim.log.levels.INFO)
    end
  end

  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return {
  { "folke/neodev.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
  { "mason-org/mason.nvim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
      },
    },
    config = function()
      require("neodev").setup({}) -- set up neovim config for Lua LSP
      vim.lsp.config.eslint = {
        settings = {
          workingDirectories = { mode = "auto" }, -- Walk up directories in monorepo
        },
      }
      require("mason").setup({
        PATH = "prepend",
      })
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
        callback = function(args)
          local wk = require("which-key")
          wk.add({
            {
              "<C-I>",
              function()
                vim.lsp.buf.code_action()
              end,
              desc = "Code actions",
            },
            { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol" },
            { "H", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show diagnostics" },
          })

          -- Disable hover for Ruff in favor of Ty
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
      local on_attach = function(client, bufnr)
        -- Highlight references when hovering over word
        if client.server_capabilities.documentHighlightProvider then
          local augroup = vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = augroup,
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = augroup,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Format on save (LSPs)
        local augroup = vim.api.nvim_create_augroup("LspAutoFormatting", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.py" },
          group = augroup,
          callback = function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source.organizeImports.ruff" }, -- Automatically run Ruff's sort command on save
              },
              apply = true,
            })
          end,
        })
      end

      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, lsp in pairs(lsps) do
        local lsp_settings = {
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
        }
        if lsp == "ty" then
          lsp_settings.before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end
          lsp_settings.settings = {
            ty = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
          }
          lsp_settings.capabilities = vim.tbl_deep_extend("force", capabilities, {
            general = {
              positionEncodings = { "utf-16" },
            },
          })
        elseif lsp == "ruff" then
          lsp_settings.cmd = { "ruff", "server" } -- no preview
          lsp_settings.capabilities = vim.tbl_deep_extend("force", capabilities, {
            general = {
              positionEncodings = { "utf-16" },
            },
          })
        elseif lsp == "starpls" then
          lsp_settings.cmd = {
            "starpls",
            "server",
            "--experimental_infer_ctx_attributes",
            "--experimental_use_code_flow_analysis",
            "--experimental_enable_label_completions",
          }
          lsp_settings.settings = {
            bazel = {
              buildifierFixOnFormat = true,
              queriesShareServer = false,
              enableCodeLens = true,
            },
          }
        end
        vim.lsp.config[lsp] = lsp_settings
      end

      vim.diagnostic.config({
        float = { border = border },
      })
    end,
  },
}
