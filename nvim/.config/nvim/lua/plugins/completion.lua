return {
  {
    "saghen/blink.cmp",
    version = "*", -- release tag ships a prebuilt fuzzy binary (no Rust build needed)
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        -- Navigate with arrows (from the `enter` preset); accept with Tab.
        -- Enter and <C-y> also accept.
        preset = "enter",
        ["<Tab>"] = { "accept", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = { auto_show = true },
        -- Preselect the top item so <CR> accepts it immediately.
        list = { selection = { preselect = true, auto_insert = false } },
      },
      signature = { enabled = true },
      -- Command-line (`:`) completion: pop the suggestion menu as you type.
      -- Tab cycles, Enter runs (cmdline keymap preset).
      cmdline = {
        completion = {
          menu = { auto_show = true },
        },
      },
    },
  },
}
