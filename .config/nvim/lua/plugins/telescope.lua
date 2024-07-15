-- Fuzzy finder
local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function find_files_frecency()
  require("telescope").extensions.smart_open.smart_open()
end

local function live_grep_from_project_git_root()
  local opts = nil

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require("telescope").extensions.live_grep_args.live_grep_args(opts)
end

local function edit_neovim()
  local opts = {
    prompt_title = "Neovim Config",
    cwd = vim.fn.stdpath("config"),
  }

  require("telescope.builtin").find_files(opts)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "tpope/vim-fugitive",
    },
    keys = {
      { "<C-p>", find_files_frecency, desc = "Find files by frecency" },
      {
        "<C-f>",
        live_grep_from_project_git_root,
        mode = { "n" },
        desc = "Live grep",
      },
      {
        "<C-f>",
        "<cmd>Telescope grep_string<CR>",
        mode = { "x" },
        desc = "Grep highlighted string",
      },
      {
        "<C-f>",
        "<cmd>Telescope command_history<CR>",
        mode = { "c" },
        desc = "Search previous commands",
      },
      { "<C-h>", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>jb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
      { "<leader>jd", "<cmd>Telescope lsp_definitions<CR>", desc = "Jump to definitions (LSP)" },
      { "<leader>ji", "<cmd>Telescope lsp_implementations<CR>", desc = "Jump to implementations (LSP)" },
      { "<leader>jk", "<cmd>Telescope keymaps<CR>", desc = "Show mappings" },
      { "<leader>jq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix list" },
      { "<leader>jr", "<cmd>Telescope lsp_references<CR>", desc = "Jump to references (LSP)" },
      { "<leader>jy", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Jump to type definitions (LSP)" },
      { "<leader>jv", edit_neovim, desc = "Edit neovim" },
    },
    config = function()
      local actions = require("telescope.actions")
      local commit = function()
        vim.cmd("Git commit")
      end
      local commit_amend = function()
        vim.cmd("Git commit --amend")
      end

      require("telescope").setup({
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
        },
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist,
              ["<C-s>"] = actions.select_horizontal,
            },
          },
          preview = {
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(path)
                local image_extensions = { "png", "jpg", "jpeg", "ico" } -- Supported image formats
                local split_path = vim.split(path:lower(), ".", { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end
              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. "\r\n")
                  end
                end
                vim.fn.jobstart({
                  "catimg",
                  filepath, -- Terminal image viewer command
                }, { on_stdout = send_output, stdout_buffered = true, pty = true })
              else
                require("telescope.previewers.utils").set_preview_message(
                  bufnr,
                  opts.winid,
                  "Binary cannot be previewed"
                )
              end
            end,
          },
        },
      })
    end,
  },

  -- native telescope sorter to significantly improve sorting performance
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "make",
  },

  {
    -- Setup telescope UI for select actions like "code_actions"
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      telescope.load_extension("ui-select")
    end,
  },

  -- intelligent ranking based on "frecency" algorithm
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          smart_open = {
            ignore_patterns = { "*/node_modules/*", "*/.git/*", "*/tmp/*" },
            match_algorithm = "fzf",
          },
        },
      })
      telescope.load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  -- live grep with arguments
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    config = function()
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")
      telescope.setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-f>"] = lga_actions.quote_prompt({ postfix = " --iglob " }), -- filter by file pattern (case insensitive)
                ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }), -- filter by filetype
              },
            },
          },
        },
      })
      telescope.load_extension("live_grep_args")
    end,
  },

  -- Easily switch to test and other files
  {
    "sshelll/telescope-switch.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = true,
    keys = {
      { "<leader>jt", "<cmd>Telescope switch<CR>", desc = "Jump to related files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          switch = {
            matchers = {
              -- Python test file
              {
                from = "(.*)/tests/test_(.*).py$",
                to = "%1/%2.py",
                name = "implementation",
              },
              {
                from = "(.*)/(.*).py$",
                to = "%1/tests/test_%2.py",
                name = "test",
                ignore_by = { "implementation" },
              },
              -- TS(X) test file
              {
                name = "implementation",
                from = "(.*)/(.*).snapshot.test.ts(x?)$",
                to = "%1/%2.ts%3",
              },
              {
                name = "implementation",
                from = "(.*)/(.*).test.ts(x?)$",
                to = "%1/%2.ts%3",
              },
              {
                name = "test",
                from = "(.*)/(.*).ts(x?)$",
                to = "%1/%2.test.ts%3",
                ignore_by = { "implementation" },
              },
              {
                name = "snapshot test",
                from = "(.*)/(.*).ts(x?)$",
                to = "%1/%2.snapshot.test.ts%3",
                ignore_by = { "implementation" },
              },
              {
                name = "story",
                from = "(.*)/(.*).stories.ts(x?)$",
                to = "%1/%2.ts%3",
              },
              {
                name = "story",
                from = "(.*)/(.*).ts(x?)$",
                to = "%1/%2.stories.ts%3",
              },
            },
            picker = {
              -- seperator = "⇒",
              layout_strategy = "horizontal",
              layout_config = {
                width = 0.8,
                height = 0.9,
                preview_cutoff = 120,
              },
              preview = true,
            },
          },
        },
      })
      telescope.load_extension("switch")
    end,
  },
}
