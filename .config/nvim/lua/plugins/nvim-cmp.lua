-- Auto-completion

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        event = "BufReadPre",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },
      {
        "windwp/nvim-autopairs",
        event = "BufReadPre",
        config = true,
        opts = {
          map_cr = true,
        },
      },
      {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = {
              auto_trigger = true,
            },
            filetypes = {
              rust = false, -- Disable for rust while learning!
              text = false,
            },
            disable_limit_reached_message = true,
            should_attach = function(bufnr)
              local filename = vim.api.nvim_buf_get_name(bufnr)

              -- Check if the file is a common Git configuration file at the root of a repo
              local git_files = {
                ".gitignore",
                ".gitattributes",
                ".gitmodules",
                "COMMIT_EDITMSG", -- common file for commit messages
                "MERGE_MSG",
              }

              local basename = vim.fn.fnamemodify(filename, ":t")
              for _, file in ipairs(git_files) do
                if basename == file then
                  return false
                end
              end

              -- Check filetypes that are often related to git operations but might be general
              local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
              if filetype == "gitcommit" or filetype == "gitrebase" then
                return false
              end

              -- Default to attaching if none of the exclusion criteria are met
              return true
            end,
          })
        end,
      },

      "luckasRanarison/tailwind-tools.nvim",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    event = "BufReadPre",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

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
            mode = "symbol_text",
            maxwidth = 50,
            before = require("tailwind-tools.cmp").lspkind_format,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          -- Integrated mappings for luasnip and cmp
          ["<CR>"] = cmp.mapping(function(fallback)
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

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local copilot = require("copilot.suggestion")
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
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
          { name = "vim-dadbod-completion" },
        }),
      })
      -- Compatibility with autopairs
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
