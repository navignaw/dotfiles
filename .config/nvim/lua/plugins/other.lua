return {
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        showMissingFiles = false,
        mappings = {
          -- Python test file
          {
            pattern = "(.*)/tests/test_(.*).py$",
            target = "%1/%2.py",
            context = "implementation"
          },
          {
            pattern = "(.*)/(.*).py$",
            target = "%1/tests/test_%2.py",
            context = "test"
          },
          -- TS(X) test file
          {
            pattern = "(.*)/(.*).test.ts(x?)$",
            target = "%1/%2.ts%3",
            context = "implementation"
          },
          {
            pattern = "(.*)/(.*).ts(x?)$",
            target = "%1/%2.test.ts%3",
            context = "test"
          },
        }
      })
    end,
    keys = {
      { "<leader>gt", function() require("other-nvim").open() end, desc = "Go to test file", },
    },
  }
}
