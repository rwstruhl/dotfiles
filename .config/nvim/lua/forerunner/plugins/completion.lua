-- blink.cmp — completion mapped onto Vim's ins-completion grammar.
--
-- Contract: nothing lands in the buffer without an explicit accept; Enter is
-- always a newline; ^N/^P/^Y/^E behave as :help ins-completion defines them.
-- If a behavior ever surprises you, the fix is to pin or delete it here.
return {
  "saghen/blink.cmp",
  version = "1.*", -- prebuilt binary; bump deliberately, schema drifts between majors
  lazy = false, -- must load before LSP clients attach so capabilities advertise snippet support

  opts = {
    keymap = {
      preset = "none", -- nothing works unless declared below
      ["<C-n>"] = { "show", "select_next" },
      ["<C-p>"] = { "select_prev" },
      ["<C-y>"] = { "select_and_accept" },
      ["<C-e>"] = { "cancel" },
      ["<C-space>"] = { "show" },
      ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      -- Enter: deliberately unmapped. Always a newline.
    },

    completion = {
      trigger = {
        show_on_keyword = true, -- auto-open while typing (the TS traversal flow)
        show_on_trigger_character = true, -- after `.` etc., LSP-driven
      },
      ghost_text = { enabled = false },
      list = {
        selection = {
          preselect = true, -- first item highlighted: Tab accepts in one press
          auto_insert = false, -- buffer is never mutated until explicit accept
        },
      },
      documentation = { auto_show = false },
      accept = { auto_brackets = { enabled = false } },
    },

    signature = { enabled = false },
    sources = { default = { "lsp", "path", "buffer" } },
  },
}
