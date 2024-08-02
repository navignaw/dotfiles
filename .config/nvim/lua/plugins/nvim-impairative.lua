local unimpaired = function()
  local impairative = require("impairative")

  impairative
    .toggling({
      enable = "[o",
      disable = "]o",
      toggle = "yo",
    })
    :option({
      key = "c",
      option = "cursorline",
    })
    :getter_setter({
      key = "d",
      name = "diff mode",
      get = function()
        return vim.o.diff
      end,
      set = function(value)
        if value then
          vim.cmd.diffthis()
        else
          vim.cmd.diffoff()
        end
      end,
    })
    :option({
      key = "l",
      option = "list",
    })
    :option({
      key = "r",
      option = "relativenumber",
    })
    :option({
      key = "s",
      option = "spell",
    })
    :option({
      key = "t",
      option = "colorcolumn",
      values = { [true] = "+1", [false] = "" },
    })
    :option({
      key = "u",
      option = "cursorcolumn",
    })
    :option({
      key = "v",
      option = "virtualedit",
      values = { [true] = "all", [false] = "" },
    })
    :option({
      key = "w",
      option = "wrap",
    })
    :getter_setter({
      key = "x",
      name = "Vim's 'cursorline' and 'cursorcolumn' options both",
      get = function()
        return vim.o.cursorline and vim.o.cursorcolumn
      end,
      set = function(value)
        vim.o.cursorline = value
        vim.o.cursorcolumn = value
      end,
    })

  impairative
    .operations({
      backward = "[",
      forward = "]",
    })
    :command_pair({
      key = "a",
      backward = "previous",
      forward = "next",
    })
    :command_pair({
      key = "A",
      backward = "first",
      forward = "last",
    })
    :command_pair({
      key = "b",
      backward = "bprevious",
      forward = "bnext",
    })
    :command_pair({
      key = "B",
      backward = "bfirst",
      forward = "blast",
    })
    :command_pair({
      key = "l",
      backward = "lprevious",
      forward = "lnext",
    })
    :command_pair({
      key = "L",
      backward = "lfirst",
      forward = "llast",
    })
    :command_pair({
      key = "<C-l>",
      backward = "lpfile",
      forward = "lnfile",
    })
    :command_pair({
      key = "q",
      backward = "cprevious",
      forward = "cnext",
    })
    :command_pair({
      key = "Q",
      backward = "cfirst",
      forward = "clast",
    })
    :command_pair({
      key = "<C-q>",
      backward = "cpfile",
      forward = "cnfile",
    })
    :command_pair({
      key = "t",
      backward = "tabprevious",
      forward = "tabnext",
    })
    :command_pair({
      key = "T",
      backward = "tabfirst",
      forward = "tablast",
    })
    :command_pair({
      key = "<C-t>",
      backward = "ptprevious",
      forward = "ptnext",
    })
    :jump_in_buf({
      key = "n",
      desc = "jump to the {previous|next} SCM conflict marker or diff/path hunk",
      extreme = {
        key = "N",
        desc = "jump to the {first|last} SCM conflict marker or diff/path hunk",
      },
      fun = require("impairative.helpers").conflict_marker_locations,
    })
    :unified_function({
      key = "<Space>",
      desc = "add blank line(s) {above|below} the current line",
      fun = function(direction)
        local line_number = vim.api.nvim_win_get_cursor(0)[1]
        if direction == "backward" then
          line_number = line_number - 1
        end
        local lines = vim.fn["repeat"]({ "" }, vim.v.count1)
        vim.api.nvim_buf_set_lines(0, line_number, line_number, true, lines)
      end,
    })
    :range_manipulation({
      key = "e",
      line_key = true,
      desc = "exchange the line(s) with [count] lines {above|below} it",
      fun = function(args)
        local target
        if args.direction == "backward" then
          target = args.start_line - args.count1 - 1
        else
          target = args.end_line + args.count1
        end
        vim.cmd({
          cmd = "move",
          range = { args.start_line, args.end_line },
          args = { target },
        })
      end,
    })
    :text_manipulation({
      key = "u",
      line_key = true,
      desc = "{encode|decode} URL",
      backward = require("impairative.helpers").encode_url,
      forward = require("impairative.helpers").decode_url,
    })
    :text_manipulation({
      key = "x",
      line_key = true,
      desc = "{encode|decode} XML",
      backward = require("impairative.helpers").encode_xml,
      forward = require("impairative.helpers").decode_xml,
    })
end

return {
  {
    "idanarye/nvim-impairative",
    event = "VeryLazy",
    config = unimpaired,
  },
}
