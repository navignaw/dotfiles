-- LSP and installers

local lsps = { "dockerls", "eslint", "lua_ls", "pyright", "ruff", "tailwindcss", "tsserver" }

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
  local configs = require("lspconfig/configs")
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
      return path.join(path.dirname(match), "bin", "python")
    end
  end

  -- Fallback to system Python.
  return exepath("python3") or exepath("python") or "python"
end

return {
  { "folke/neodev.nvim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
      },
    },
    config = function()
      require("neodev").setup({}) -- set up neovim config for Lua LSP
      local lspconfig = require("lspconfig")
      require("mason").setup({
        PATH = "prepend",
      })
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          local wk = require("which-key")
          wk.register({
            H = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show diagnostics" },
            ["<C-I>"] = {
              function()
                vim.lsp.buf.code_action()
              end,
              "Code actions",
            },
            ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
          })
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
          pattern = { "*.lua", "*.py" },
          group = augroup,
          callback = function()
            vim.lsp.buf.format({ async = false })
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
        if lsp == "pyright" then
          lsp_settings.before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end
        end
        lspconfig[lsp].setup(lsp_settings)
      end

      vim.diagnostic.config({
        float = { border = border },
      })
    end,
  },
}
