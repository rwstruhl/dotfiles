return {
  "neovim/nvim-lspconfig",

  config = function()
    -- Language servers are installed outside Neovim. Use :checkhealth vim.lsp
    -- to see which enabled configurations have an executable available.
    local ts_projects = {}

    -- DiffView tabs exist for reviewing changes, not editing, and servers add
    -- nothing there. Its revision buffers carry synthetic names like
    -- `diffview://<repo>/<rev>/<path>`, which filetype detection happily maps
    -- back to JS/TS, so gates belong in root_dir before any client starts.
    local function is_diffview_buf(bufnr)
      if vim.bo[bufnr].filetype == "DiffviewFiles" then
        return true
      end
      if vim.api.nvim_buf_get_name(bufnr):find("^diffview://") then
        return true
      end
      -- The working-tree side of a diff is a real file buffer; check whether
      -- it is displayed inside a DiffView tabpage.
      local ok, lib = pcall(require, "diffview.lib")
      if not ok then
        return false
      end
      local win = vim.fn.bufwinid(bufnr)
      if win == -1 then
        return false
      end
      return lib.tabpage_to_view(vim.api.nvim_win_get_tabpage(win)) ~= nil
    end

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
        if is_diffview_buf(bufnr) then
          return
        end
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
        if is_diffview_buf(bufnr) then
          return
        end
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

    local eslint_root_dir = vim.lsp.config.eslint.root_dir
    vim.lsp.config("eslint", {
      root_dir = function(bufnr, on_dir)
        if not is_diffview_buf(bufnr) then
          eslint_root_dir(bufnr, on_dir)
        end
      end,
      settings = {
        format = false,
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("forerunner_lsp", { clear = true }),
      desc = "Configure LSP client behavior",
      callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        -- Safety net for servers with stock configs (ruff, rust_analyzer,
        -- basedpyright, ...): if anything still attaches inside DiffView,
        -- drop it right away.
        if is_diffview_buf(event.buf) then
          vim.lsp.buf_detach_client(event.buf, client.id)
          return
        end

        -- Basedpyright owns Python language intelligence; Ruff owns linting
        -- and fixes. JavaScript linters remain diagnostic/code-action providers.
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        elseif client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
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
