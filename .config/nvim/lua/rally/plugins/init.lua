return {
  -- TPope Essentials
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile", }, },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile", }, },
  { "tpope/vim-commentary", event = { "BufReadPost", "BufNewFile", }, },

  -- Undo Tree
  {
    "mbbill/undotree",
    keys = {
      { "<Leader>u", ":UndotreeToggle<CR>", desc = "Toggle undo tree", }
    }
  },

  -- Which Key
  {"folke/which-key.nvim", event = "VeryLazy", opts = {}},

  -- Copilot
  {"github/copilot.vim", event = { "BufReadPost", "BufNewFile", }, },
}
