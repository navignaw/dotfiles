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
  local opts = {}

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require("telescope.builtin").live_grep(opts)
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
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
      { "<leader>ev", edit_neovim, desc = "Edit neovim" },
      { "<leader>k", "<cmd>Telescope keymaps<CR>", desc = "Show mappings" },
      { "<leader>qf", "<cmd>Telescope quickfix<CR>", desc = "Quickfix list" },
      { "<leader>d", "<cmd>Telescope lsp_definitions<CR>", desc = "Jump to definitions (LSP)" },
      { "<leader>i", "<cmd>Telescope lsp_implementations<CR>", desc = "Jump to implementations (LSP)" },
      { "<leader>r", "<cmd>Telescope lsp_references<CR>", desc = "Jump to references (LSP)" },
      { "<leader>t", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Jump to type definitions (LSP)" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
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
          git_status = {
            mappings = {
              i = {
                ["<C-a>"] = commit_amend,
                ["<C-c>"] = commit,
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
}
