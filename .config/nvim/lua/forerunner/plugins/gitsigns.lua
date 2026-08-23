return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          silent = true,
          noremap = true,
          desc = desc,
        })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous change")

      map("n", "<Leader>hp", gs.preview_hunk_inline, "Prevew hunk")
      map("n", "<Leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")

      map("n", "<Leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<Leader>hr", gs.reset_hunk, "Reset hunk")
      map("n", "<Leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

      map("x", "<Leader>hs", function()
        gs.stage_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, "Stage selected lines")

      map("x", "<Leader>hr", function()
        gs.reset_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, "Reset selected lines")

      map({ "o", "x" }, "ih", gs.select_hunk, "Git hunk")
      map("n", "<Leader>hq", gs.setqflist, "Hunks to quickfix")
      map("n", "<Leader>hQ", function()
        gs.setqflist("all")
      end, "All hunks to quickfix")

      map("n", "<Leader>hh", gs.toggle_signs, "Toggle gitsigns")

    end,
  }
}
