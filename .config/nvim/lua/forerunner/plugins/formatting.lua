local biome_configs = { "biome.json", "biome.jsonc" }
local oxfmt_configs = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
}
local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".prettierrc.toml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.ts",
  ".prettierrc.cts",
  ".prettierrc.mts",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
  "prettier.config.cts",
  "prettier.config.mts",
}

local function project_file(bufnr, names)
  return vim.fs.find(names, {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = "file",
    limit = 1,
  })[1]
end

local function project_executable(bufnr, name)
  local node_modules = vim.fs.find("node_modules", {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = "directory",
    limit = math.huge,
  })

  for _, directory in ipairs(node_modules) do
    if vim.fn.executable(vim.fs.joinpath(directory, ".bin", name)) == 1 then
      return true
    end
  end

  return false
end

local function package_uses_prettier(package_json)
  if not package_json then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, package_json)
  if not ok then
    return false
  end

  local decoded_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded_ok and type(package) == "table" and package.prettier ~= nil
end

local function javascript_formatter(bufnr)
  if project_file(bufnr, biome_configs) then
    return { "biome" }
  end

  if project_file(bufnr, oxfmt_configs) then
    return { "oxfmt" }
  end

  local package_json = project_file(bufnr, { "package.json" })

  if project_file(bufnr, prettier_configs) or package_uses_prettier(package_json) then
    return { "prettier" }
  end

  if project_executable(bufnr, "oxfmt") then
    return { "oxfmt" }
  end
  if project_executable(bufnr, "prettier") then
    return { "prettier" }
  end
  if vim.fn.executable("oxfmt") == 1 then
    return { "oxfmt" }
  end
  if vim.fn.executable("prettier") == 1 then
    return { "prettier" }
  end

  return {}
end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "ConformInfo",
  keys = {
    {
      "<Leader>=",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      javascript = javascript_formatter,
      javascriptreact = javascript_formatter,
      typescript = javascript_formatter,
      typescriptreact = javascript_formatter,
    },
    formatters = {
      oxfmt = {
        -- Include the current .mts config name even if Conform's bundled
        -- formatter definition has not learned it yet.
        cwd = function(_, context)
          return vim.fs.root(context.dirname, oxfmt_configs)
        end,
      },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("forerunner_formatting", { clear = true }),
      desc = "Use Conform for the gq operator",
      pattern = {
        "lua",
        "python",
        "rust",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      callback = function(event)
        vim.bo[event.buf].formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    })
  end,
}
