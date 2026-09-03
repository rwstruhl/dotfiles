vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Numbering
opt.number = true
-- opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- General
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"

-- Colors
opt.termguicolors = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Mouse
opt.mouse = "a"

-- Logical split behavior
opt.splitbelow = true
opt.splitright = true

-- Scroll offset (mandatory above / below padding)
opt.scrolloff = 10

-- Show matching brace
opt.showmatch = true

-- Faster update cycle
opt.updatetime = 50

-- Diagnostics (explicit, so upstream default changes don't drift in)
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded", source = "if_many" },
})

-- Netrw split fix
local augroup = vim.api.nvim_create_augroup("netrw_fix", {clear = true})
vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  group = augroup,
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<c-l>", "<c-w>l", {noremap = true, silent = true})
  end
})
