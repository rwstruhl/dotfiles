return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<Leader>p", function() require("telescope.builtin").find_files() end, desc = "Scope [p]roject files", },
    { "<c-p>", function() require("telescope.builtin").oldfiles() end, desc = "Scope [p]roject files", },
    { "<Leader>b", function() require("telescope.builtin").buffers() end, desc = "Scope [b]uffers", },
    { "<Leader>f", function() require("telescope.builtin").live_grep() end, desc = "Scope [f]ind within project", },
    { "<Leader>c", function() require("telescope.builtin").colorscheme() end, desc = "Scope [c]olorscheme", },
    { "<Leader>ss", function() require("telescope.builtin").resume() end, desc = " Re[s]ume [s]cope", },
    { "<Leader>.", function() require("telescope.builtin").grep_string() end, desc = "[.] Scope grep current word", },
    { "<Leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "[s]cope [d]iagnostics", },
    { "<Leader>sg", function() require("telescope.builtin").git_files() end, desc = "[s]cope [g]it", },
    { "<Leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[s]cope [h]elp", },
    { "<Leader>st", function() require("telescope.builtin").treesitter() end, desc = "[s]cope [t]reesitter", },
    { "<Leader>sb", function() require("telescope.builtin").git_branches() end, desc = "[s]cope git [b]ranches", },
    { "<Leader>sx", function() require("telescope.builtin").git_stash() end, desc = "[s]cope git stash", },
    { "<Leader>sl", function() require("telescope.builtin").git_bcommits() end, desc = "[s]cope git buffer commits", },
    { "<Leader>sj", function() require("telescope.builtin").git_commits() end, desc = "[s]cope git commits", },
  },
  config = function()
    require("telescope").setup {
      defaults = {
        mappings = {
          i = {
            ["<Esc>"] = require("telescope.actions").close,
            ["<C-q>"] = require("telescope.actions").smart_send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          }
        }
      }
    }
  end,
}
