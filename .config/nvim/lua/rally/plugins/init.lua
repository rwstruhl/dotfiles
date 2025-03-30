return {
  -- TPope Essentials
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile", }, },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile", }, },
  { "tpope/vim-commentary", event = { "BufReadPost", "BufNewFile", }, },

  -- Harpoon
  {"theprimeagen/harpoon", event = "VeryLazy", },

  -- Undo Tree
  {"mbbill/undotree", event = { "BufReadPost", "BufNewFile", }, },

  -- Which Key
  {"folke/which-key.nvim", event = "VeryLazy", opts = {}},

  -- Copilot
  {"github/copilot.vim", event = { "BufReadPost", "BufNewFile", }, },
}
