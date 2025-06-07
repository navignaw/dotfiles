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
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        on_attach = function()
          local wk = require("which-key")

          -- Navigation
          wk.add({
            {
              "[h",
              function()
                nav_hunk("prev")
              end,
              desc = "Previous changed hunk",
            },
            {
              "]h",
              function()
                nav_hunk("next")
              end,
              desc = "Next changed hunk",
            },
          })

          -- Hunk actions
          wk.add({
            { "<leader>h", group = "Hunk" },
            {
              "<leader>hD",
              function()
                gitsigns.diffthis("~")
              end,
              desc = "Diff hunk (reverse)",
            },
            { "<leader>hR", gitsigns.reset_buffer, desc = "Reset buffer" },
            { "<leader>hS", gitsigns.stage_buffer, desc = "Stage buffer" },
            {
              "<leader>hb",
              function()
                gitsigns.blame_line({ full = true })
              end,
              desc = "Blame line",
            },
            { "<leader>hd", gitsigns.diffthis, desc = "Diff hunk" },
            { "<leader>hp", gitsigns.preview_hunk, desc = "Preview hunk" },
            { "<leader>hr", gitsigns.reset_hunk, desc = "Reset hunk" },
            { "<leader>hs", gitsigns.stage_hunk, desc = "Stage hunk" },
            { "<leader>ht", group = "Toggle" },
            { "<leader>htb", gitsigns.toggle_current_line_blame, desc = "Toggle blame" },
            { "<leader>htd", gitsigns.toggle_deleted, desc = "Toggle deleted" },
            { "<leader>hu", gitsigns.undo_stage_hunk, desc = "Undo stage hunk" },
          })
        end,
      })
    end,
  },

  -- Better Git UI
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
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
      wk.add({
        { "<leader>gh", group = "Github" },
        { "<leader>ghc", group = "Commits" },
        { "<leader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
        { "<leader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
        { "<leader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
        { "<leader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
        { "<leader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
        { "<leader>ghi", group = "Issues" },
        { "<leader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
        { "<leader>ghl", group = "Litee" },
        { "<leader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
        { "<leader>ghp", group = "Pull Request" },
        { "<leader>ghpc", "<cmd>GHClosePR<cr>", desc = "Close" },
        { "<leader>ghpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
        { "<leader>ghpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
        { "<leader>ghpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
        { "<leader>ghpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
        { "<leader>ghpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
        { "<leader>ghpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
        { "<leader>ghr", group = "Review" },
        { "<leader>ghrb", "<cmd>GHStartReview<cr>", desc = "Begin" },
        { "<leader>ghrc", "<cmd>GHCloseReview<cr>", desc = "Close" },
        { "<leader>ghrd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
        { "<leader>ghre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
        { "<leader>ghrs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
        { "<leader>ghrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
        { "<leader>ght", group = "Threads" },
        { "<leader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
        { "<leader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next" },
        { "<leader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
        { "<leader>pr", group = "PR" },
        { "<leader>pro", "<cmd>GHOpenPR<cr>", desc = "Open" },
        { "<leader>prr", "<cmd>GHRequestedReview<cr>", desc = "Requested Review" },
        { "<leader>prs", "<cmd>GHSearchPRs<cr>", desc = "Search" },
      })
    end,
  },
}
