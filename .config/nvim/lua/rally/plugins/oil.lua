return {
  'stevearc/oil.nvim',
  keys={
    {"-", "<cmd>Oil<cr>", {desc = "Open oil"}},
    {"<leader>o", "<cmd>Oil<cr>", {desc = "Open oil"}},
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-p>"] = "actions.preview",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
    use_default_keymaps = false,
  },
  dependencies = { "nvim-tree/nvim-web-devicons" }
}
