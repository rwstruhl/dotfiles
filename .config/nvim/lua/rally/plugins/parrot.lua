return {
  "frankroeder/parrot.nvim",
  tag = "v0.4.2",
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  -- optionally include "rcarriga/nvim-notify" for beautiful notifications
  config = function()
    require("parrot").setup {
      -- Providers must be explicitly added to make them available.
      providers = {
        openai = {
          api_key = {"op", "read", "op://Private/auth0.openai.com/rally-laptop-sk", "--no-newline"},
        },
        anthropic = {
          api_key = {"op", "read", "op://Private/xcgw6lfplgntutmhdq2q6ark4y/laptop-api-Key", "--no-newline"},
        },
        ollama = {}
      },
    }
  end,
}
