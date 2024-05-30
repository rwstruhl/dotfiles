return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", config = true },
    { "SmiteshP/nvim-navic" },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local navic = require("nvim-navic")

    local keymap = vim.keymap
    local opt = { noremap = true, silent = true }

    local onAttach = function(client, bufnr)
      opt.buffer = bufnr

      -- Turn off semantic highlighting
      client.server_capabilities.semanticTokensProvider = nil

      -- Attach navic to buffer
      navic.attach(client, bufnr)

      opt.desc = "Go to definition"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opt)

      opt.desc = "Code Actions"
      keymap.set("n", "<leader>m", vim.lsp.buf.code_action, opt)

      opt.desc = "Rename variable"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opt)

      opt.desc = "Go to references"
      keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opt)

      opt.desc = "Go to implementation"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opt)

      opt.desc = "Go to type definition"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opt)

      opt.desc = "Go to declaration"
      keymap.set("n", "gD", "<cmd>Telescope lsp_declarations<CR>", opt)

      opt.desc = "Buffer Diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opt)

      opt.desc = "Line Diagnostics"
      keymap.set("n", "<leader>d",vim.diagnostic.open_float, opt)

      opt.desc = "Next Diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opt)

      opt.desc = "Previous Diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opt)

      opt.desc = "LSP hover"
      keymap.set("n", "<leader>j", vim.lsp.buf.hover, opt)

      opt.desc = "Restart LSP"
      keymap.set("n", "<leader>xx", "<cmd>LspRestart<cr>", opt)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })

    lspconfig["tsserver"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })

    lspconfig["rust_analyzer"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })

    lspconfig["wgsl_analyzer"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
          },
        },
      },
    })

    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = onAttach,
    })
  end
}
