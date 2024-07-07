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
            context = "implementation",
          },
          {
            pattern = "(.*)/(.*).py$",
            target = "%1/tests/test_%2.py",
            context = "test",
          },
          -- TS(X) test file
          {
            pattern = "(.*)/(.*).snapshot.test.ts(x?)$",
            target = "%1/%2.ts%3",
            context = "implementation",
          },
          {
            pattern = "(.*)/(.*).test.ts(x?)$",
            target = "%1/%2.ts%3",
            context = "implementation",
          },
          {
            pattern = "(.*)/(.*).ts(x?)$",
            target = "%1/%2.test.ts%3",
            context = "test",
          },
          {
            pattern = "(.*)/(.*).ts(x?)$",
            target = "%1/%2.snapshot.test.ts%3",
            context = "snapshot test",
          },
          {
            pattern = "(.*)/(.*).stories.ts(x?)$",
            target = "%1/%2.ts%3",
            context = "story",
          },
          {
            pattern = "(.*)/(.*).ts(x?)$",
            target = "%1/%2.stories.ts%3",
            context = "story",
          },
        },
      })
    end,
    keys = {
      {
        "<leader>gt",
        function()
          require("other-nvim").open()
        end,
        desc = "Go to test file",
      },
      {
        "<leader>gs",
        function()
          require("other-nvim").open("story")
        end,
        desc = "Go to story file",
      },
    },
  },
}
