-- Syntax highlighting

local parsers = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "ruby",
  "sql",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

-- Filetypes that should not get treesitter highlighting
local highlight_disabled = { ["yaml.gha"] = true }

local function textobject_keymaps()
  local select = require("nvim-treesitter-textobjects.select")
  local swap = require("nvim-treesitter-textobjects.swap")
  local move = require("nvim-treesitter-textobjects.move")

  local selects = {
    -- You can use the capture groups defined in textobjects.scm
    ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
    ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
    ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
    ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },

    -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
    ["a:"] = { "@property.outer", "Select outer part of an object property" },
    ["i:"] = { "@property.inner", "Select inner part of an object property" },
    ["l:"] = { "@property.lhs", "Select left part of an object property" },
    ["r:"] = { "@property.rhs", "Select right part of an object property" },

    ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
    ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },

    ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
    ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },

    ["al"] = { "@loop.outer", "Select outer part of a loop" },
    ["il"] = { "@loop.inner", "Select inner part of a loop" },

    ["af"] = { "@call.outer", "Select outer part of a function call" },
    ["if"] = { "@call.inner", "Select inner part of a function call" },

    ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
    ["im"] = { "@function.inner", "Select inner part of a method/function definition" },

    ["ac"] = { "@class.outer", "Select outer part of a class" },
    ["ic"] = { "@class.inner", "Select inner part of a class" },
  }
  for lhs, spec in pairs(selects) do
    vim.keymap.set({ "x", "o" }, lhs, function()
      select.select_textobject(spec[1], "textobjects")
    end, { desc = spec[2] })
  end

  local swaps = {
    ["<leader>na"] = { "swap_next", "@parameter.inner", "Swap parameter/argument with next" },
    ["<leader>n:"] = { "swap_next", "@property.outer", "Swap object property with next" },
    ["<leader>nm"] = { "swap_next", "@function.outer", "Swap function with next" },
    ["<leader>pa"] = { "swap_previous", "@parameter.inner", "Swap parameter/argument with prev" },
    ["<leader>p:"] = { "swap_previous", "@property.outer", "Swap object property with prev" },
    ["<leader>pm"] = { "swap_previous", "@function.outer", "Swap function with previous" },
  }
  for lhs, spec in pairs(swaps) do
    vim.keymap.set("n", lhs, function()
      swap[spec[1]](spec[2])
    end, { desc = spec[3] })
  end

  -- { lhs = { method, query, query_group, desc } }
  local moves = {
    ["]f"] = { "goto_next_start", "@call.outer", "textobjects", "Next function call start" },
    ["]m"] = { "goto_next_start", "@function.outer", "textobjects", "Next method/function def start" },
    ["]c"] = { "goto_next_start", "@class.outer", "textobjects", "Next class start" },
    ["]i"] = { "goto_next_start", "@conditional.outer", "textobjects", "Next conditional start" },
    ["]l"] = { "goto_next_start", "@loop.outer", "textobjects", "Next loop start" },
    ["]s"] = { "goto_next_start", "@local.scope", "locals", "Next scope" },
    ["]z"] = { "goto_next_start", "@fold", "folds", "Next fold" },

    ["]F"] = { "goto_next_end", "@call.outer", "textobjects", "Next function call end" },
    ["]M"] = { "goto_next_end", "@function.outer", "textobjects", "Next method/function def end" },
    ["]C"] = { "goto_next_end", "@class.outer", "textobjects", "Next class end" },
    ["]I"] = { "goto_next_end", "@conditional.outer", "textobjects", "Next conditional end" },
    ["]L"] = { "goto_next_end", "@loop.outer", "textobjects", "Next loop end" },

    ["[f"] = { "goto_previous_start", "@call.outer", "textobjects", "Prev function call start" },
    ["[m"] = { "goto_previous_start", "@function.outer", "textobjects", "Prev method/function def start" },
    ["[c"] = { "goto_previous_start", "@class.outer", "textobjects", "Prev class start" },
    ["[i"] = { "goto_previous_start", "@conditional.outer", "textobjects", "Prev conditional start" },
    ["[l"] = { "goto_previous_start", "@loop.outer", "textobjects", "Prev loop start" },

    ["[F"] = { "goto_previous_end", "@call.outer", "textobjects", "Prev function call end" },
    ["[M"] = { "goto_previous_end", "@function.outer", "textobjects", "Prev method/function def end" },
    ["[C"] = { "goto_previous_end", "@class.outer", "textobjects", "Prev class end" },
    ["[I"] = { "goto_previous_end", "@conditional.outer", "textobjects", "Prev conditional end" },
    ["[L"] = { "goto_previous_end", "@loop.outer", "textobjects", "Prev loop end" },
  }
  for lhs, spec in pairs(moves) do
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
      move[spec[1]](spec[2], spec[3])
    end, { desc = spec[4] })
  end
end

return {
  { "yasuhiroki/github-actions-yaml.vim" },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter").install(parsers)

      -- jsonc parser was dropped on main; the json parser handles comments
      vim.treesitter.language.register("json", "jsonc")

      local filetypes = { "jsonc" }
      for _, lang in ipairs(parsers) do
        vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        pattern = filetypes,
        callback = function(args)
          if highlight_disabled[vim.bo[args.buf].filetype] then
            return
          end
          -- pcall: parser may still be installing on first launch
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Incremental selection, using Neovim 0.12's built-in `an` / `in` node selection
      vim.keymap.set("n", "V", "van", { remap = true, desc = "Start treesitter node selection" })
      vim.keymap.set("x", "V", "an", { remap = true, desc = "Expand selection to parent node" })
      vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink selection to child node" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    init = function()
      -- Disable built-in ftplugin mappings (e.g. python's ]m) so ours take effect
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      })
      textobject_keymaps()
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
    lazy = true,
  },
}
