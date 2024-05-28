-- LSP and installers

local lsps = { 'eslint', 'lua_ls', 'pyright', 'ruff', 'tailwindcss', 'tsserver' }

return {
  { 'folke/neodev.nvim' },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      }
    },
    config = function()
      require("neodev").setup({}) -- set up neovim config for Lua LSP
      local lspconfig = require('lspconfig')
      require('mason').setup({
        PATH = 'prepend'
      })
      require('mason-lspconfig').setup({
        ensure_installed = lsps
      })
      local map = function(type, key, value)
        vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true })
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function()
          map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
          map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        end,
      })
      local on_attach = function(client, bufnr)
        -- Highlight references when hovering over word
        if client.server_capabilities.documentHighlightProvider then
          local augroup = vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = augroup,
          })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = augroup,
            buffer = bufnr,
            callback = function()
              -- Show diagnostics in float window if in normal mode
              if vim.api.nvim_get_mode().mode == 'n' then
                vim.diagnostic.open_float()
              end
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = augroup,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Format on save (LSPs)
        local augroup = vim.api.nvim_create_augroup('LspAutoFormatting', {})
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.lua', '*.py' },
          group = augroup,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, lsp in pairs(lsps) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}
