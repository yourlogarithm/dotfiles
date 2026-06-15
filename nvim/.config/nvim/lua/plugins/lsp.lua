return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Servers to install + enable (mason-lspconfig names).
      local servers = {
        "rust_analyzer",
        "gopls",
        "basedpyright",
        "ruff",
        "lua_ls",
        "clangd",
        "omnisharp",
        "jdtls",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true, -- enables installed servers via vim.lsp.enable (nvim 0.11)
      })

      -- Default config applied to every server (completion capabilities).
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- lua_ls: recognise the `vim` global when editing this config.
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- rust_analyzer: keep native diagnostics on (NOTE: `diagnostics.enable`
      -- is the master switch — disabling it suppresses ALL diagnostics,
      -- including the `cargo check` ones, which is why errors weren't showing)
      -- and run `cargo check` on save for borrow-checker / full error codes.
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
          },
        },
      })

      -- Buffer-local keymaps when a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(ev)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Definition")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Implementation")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end,
  },
}
