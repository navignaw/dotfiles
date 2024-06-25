-- Git configuration

local function nav_hunk(direction)
  local gitsigns = require("gitsigns")
  if vim.wo.diff then
    local cmd = direction == "prev" and "]c" or "[c"
    vim.cmd.normal({ cmd, bang = true })
  else
    gitsigns.nav_hunk(direction)
  end
end

return {
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function()
          local gitsigns = require("gitsigns")
          local wk = require("which-key")

          -- Navigation
          wk.register({
            ["[c"] = { function() nav_hunk('prev') end, 'Previous changed hunk' },
            ["]c"] = { function() nav_hunk('next') end, 'Next changed hunk' },
          })

          -- Hunk actions
          wk.register({
            name = "+Hunk",
            s = { gitsigns.stage_hunk, "Stage hunk" },
            r = { gitsigns.reset_hunk, "Reset hunk" },
            S = { gitsigns.stage_buffer, "Stage buffer" },
            u = { gitsigns.undo_stage_hunk, "Undo stage hunk" },
            R = { gitsigns.reset_buffer, "Reset buffer" },
            p = { gitsigns.preview_hunk, "Preview hunk" },
            b = { function() gitsigns.blame_line { full = true } end, "Blame line" },
            d = { gitsigns.diffthis, "Diff hunk" },
            D = { function() gitsigns.diffthis("~") end, "Diff hunk (reverse)" },
            t = {
              name = "Toggle",
              b = { gitsigns.toggle_current_line_blame, "Toggle blame" },
              d = { gitsigns.toggle_deleted, "Toggle deleted" },
            },
          }, { prefix = "<leader>h" })
        end
      }
    end,
  },

  { 'tpope/vim-fugitive' },
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = function()
      require('git-conflict').setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = true,
        list_opener = 'copen',
      })
    end,
  },

  -- PR Reviews in Neovim!
  {
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup({
        icon_set = "nerd",
      })

      local wk = require("which-key")
      wk.register({
        -- Shortcuts for pull request
        pr = {
          name = "+PR",
          o = { "<cmd>GHOpenPR<cr>", "Open" },
          r = { "<cmd>GHRequestedReview<cr>", "Requested Review" },
          s = { "<cmd>GHSearchPRs<cr>", "Search" },
        },
        g = {
          name = "+Git",
          h = {
            name = "+Github",
            c = {
              name = "+Commits",
              c = { "<cmd>GHCloseCommit<cr>", "Close" },
              e = { "<cmd>GHExpandCommit<cr>", "Expand" },
              o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
              p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
              z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
            },
            i = {
              name = "+Issues",
              p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
            },
            l = {
              name = "+Litee",
              t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
            },
            r = {
              name = "+Review",
              b = { "<cmd>GHStartReview<cr>", "Begin" },
              c = { "<cmd>GHCloseReview<cr>", "Close" },
              d = { "<cmd>GHDeleteReview<cr>", "Delete" },
              e = { "<cmd>GHExpandReview<cr>", "Expand" },
              s = { "<cmd>GHSubmitReview<cr>", "Submit" },
              z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
            },
            p = {
              name = "+Pull Request",
              c = { "<cmd>GHClosePR<cr>", "Close" },
              d = { "<cmd>GHPRDetails<cr>", "Details" },
              e = { "<cmd>GHExpandPR<cr>", "Expand" },
              p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
              r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
              t = { "<cmd>GHOpenToPR<cr>", "Open To" },
              z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
            },
            t = {
              name = "+Threads",
              c = { "<cmd>GHCreateThread<cr>", "Create" },
              n = { "<cmd>GHNextThread<cr>", "Next" },
              t = { "<cmd>GHToggleThread<cr>", "Toggle" },
            },
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
}
