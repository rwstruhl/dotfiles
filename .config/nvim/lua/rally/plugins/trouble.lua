return {
  "folke/trouble.nvim",
  keys = {
    {"<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble toggle buf"},
    {"<leader>tT", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble toggle project"},
    {"<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble quickfix"},
    {"<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble loclist"},
  },
  opts = {}
}
