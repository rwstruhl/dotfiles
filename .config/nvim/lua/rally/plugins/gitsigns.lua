return {
  'lewis6991/gitsigns.nvim',
  event = {"BufReadPre", "BufNewFile"},
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Diff hunk navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gs.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gs.nav_hunk('prev')
        end
      end)

      -- General Keybindings
      map('n', '<leader>gb', gs.toggle_current_line_blame, { noremap = true, desc = "Toggle git blame" })
      map('n', '<leader>gs', gs.stage_hunk, { noremap = true, desc = "Stage hunk" })
      map('n', '<leader>gr', gs.reset_hunk, { noremap = true, desc = "Reset hunk" })
      map('n', '<leader>gS', gs.stage_buffer, { noremap = true, desc = "Stage current buffer" })
      map('n', '<leader>gR', gs.reset_buffer, { noremap = true, desc = "Reset current buffer" })
      map('n', '<leader>gp', gs.preview_hunk_inline, { noremap = true, desc = "Preview hunk" })
      map('n', '<leader>gd', gs.diffthis, { noremap = true, desc = "Diff the current line" })
      map('n', '<leader>gD', function () gs.diffthis('~') end, { noremap = true, desc = "Diff the current buffer" })
      map('n', '<leader>gg', gs.toggle_signs, { noremap = true, desc = "Toggle git signs column" })
    end
  }
}
