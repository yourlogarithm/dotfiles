return {
  {
    "saghen/blink.cmp",
    version = "*", -- release tag ships a prebuilt fuzzy binary (no Rust build needed)
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        -- The `default` preset gives exactly the behaviour we want, no overrides:
        --   <C-y>          accept the completion (the ONLY accept key)
        --   <CR>           literal newline -- never accepts
        --   <Up>/<Down>    navigate the menu  (<C-n>/<C-p> too)
        --   <Tab>/<S-Tab>  jump forward/backward through snippet placeholders,
        --                  falling back to a literal Tab outside a snippet
        --   <C-Space>      trigger the menu   <C-e> dismiss
        preset = "default",
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
