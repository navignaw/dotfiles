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
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
        })
      end

      vim.diagnostic.config({
        float = { border = border },
      })
    end,
  },
}
