return {
  "neovim/nvim-lspconfig",

  config = function()
    -- Language servers are installed outside Neovim. Use :checkhealth vim.lsp
    -- to see which enabled configurations have an executable available.
    local ts_projects = {}

    local function supports_native_typescript(command)
      if vim.fn.executable(command) ~= 1 then
        return false
      end

      local result = vim.system({ command, "--version" }, { text = true }):wait()
      local version = result.code == 0 and vim.version.parse(result.stdout or "") or nil
      return version ~= nil and version.major >= 7
    end

    local function typescript_root(bufnr)
      local lockfiles = {
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "bun.lockb",
        "bun.lock",
      }
      local project_root = vim.fs.root(bufnr, { lockfiles, { ".git" } })
      local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
      local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })

      if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
        return nil
      end
      if deno_root and (not project_root or #deno_root >= #project_root) then
        return nil
      end

      return project_root or vim.fn.getcwd()
    end

    local function typescript_for_root(root)
      root = vim.fs.normalize(root)
      if ts_projects[root] then
        return ts_projects[root]
      end

      local local_tsc = vim.fs.joinpath(root, "node_modules", ".bin", "tsc")
      local selection

      if vim.fn.executable(local_tsc) == 1 then
        selection = {
          native = supports_native_typescript(local_tsc),
          command = local_tsc,
        }
      elseif supports_native_typescript("tsc") then
        selection = { native = true, command = "tsc" }
      else
        selection = { native = false }
      end

      ts_projects[root] = selection
      return selection
    end

    local function typescript_root_dir(use_native)
      return function(bufnr, on_dir)
        local root = typescript_root(bufnr)
        if root and typescript_for_root(root).native == use_native then
          on_dir(root)
        end
      end
    end

    vim.lsp.config("tsc", {
      root_dir = typescript_root_dir(true),
      cmd = function(dispatchers, config)
        local selection = typescript_for_root(assert(config.root_dir))
        return vim.lsp.rpc.start({ assert(selection.command), "--lsp", "--stdio" }, dispatchers)
      end,
    })

    vim.lsp.config("ts_ls", {
      root_dir = typescript_root_dir(false),
    })

    local oxlint_root_dir = vim.lsp.config.oxlint.root_dir
    vim.lsp.config("oxlint", {
      root_dir = function(bufnr, on_dir)
        local found_root = false
        oxlint_root_dir(bufnr, function(root)
          if root then
            found_root = true
            on_dir(root)
          end
        end)

        -- Supported by Oxlint, but not yet present in all lspconfig releases.
        if not found_root then
          local config = vim.fs.find("oxlint.config.mts", {
            path = vim.api.nvim_buf_get_name(bufnr),
            upward = true,
            type = "file",
            limit = 1,
          })[1]
          if config then
            on_dir(vim.fs.dirname(config))
          end
        end
      end,
    })

    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
        },
      },
    })

    vim.lsp.config("eslint", {
      settings = {
        format = false,
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("forerunner_lsp", { clear = true }),
      desc = "Configure LSP client behavior",
      callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        -- Basedpyright owns Python language intelligence; Ruff owns linting
        -- and fixes. JavaScript linters remain diagnostic/code-action providers.
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        elseif client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
        end
      end,
    })

    vim.lsp.enable({
      "lua_ls",
      "basedpyright",
      "ruff",
      "rust_analyzer",
      "eslint",
      "oxlint",
      "tsc",
      "ts_ls",
    })
  end,
}
