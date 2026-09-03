return {
  "neovim-treesitter/nvim-treesitter",
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local treesitter = require("nvim-treesitter")

    local parsers = {
      "bash",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    -- install() is asynchronous and skips parsers that are already installed.
    treesitter.install(parsers)

    local group = vim.api.nvim_create_augroup("treesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "*",
      callback = function(args)
        -- This also picks up parsers installed later with :TSInstall.
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
