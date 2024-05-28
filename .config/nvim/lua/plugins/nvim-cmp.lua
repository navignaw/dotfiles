-- Auto-completion

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        event = 'BufReadPre',
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
      },
      {
        'windwp/nvim-autopairs',
        event = 'BufReadPre',
        config = true,
        opts = {
          map_cr = true,
        }
      },
      {
        'zbirenbaum/copilot.lua',
        event = 'InsertEnter',
        config = function()
          require('copilot').setup({
            suggestion = {
              auto_trigger = true,
            }
          })
        end,
      },

      'onsails/lspkind-nvim',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    event = 'BufReadPre',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          expandable_indicator = true,
          fields = { cmp.ItemField.Abbr, cmp.ItemField.Kind },
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          -- Integrated mappings for luasnip and cmp
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            local copilot = require('copilot.suggestion')
            if copilot.is_visible() then
              if cmp.visible() and cmp.get_selected_entry() then
                -- If completion menu is open, select previous item
                cmp.select_prev_item()
              else
                copilot.accept()
              end
            elseif cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        })
      })
      -- Compatibility with autopairs
      cmp.event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
      )
    end,
  },
}
