return {
  { "tpope/vim-vinegar", lazy = false },
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-commentary", event = { "BufReadPost", "BufNewFile" } },

  { 
    "tpope/vim-fugitive", 
    cmd = "Git", 
    keys = {
      { "<Leader><Leader>", "<cmd>Git<cr>", {desc = "Git status"} }
    },
  },
}
