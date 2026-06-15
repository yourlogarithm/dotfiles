return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- `main` is the actively-maintained branch. The old `master` branch is EOL
    -- and breaks on Neovim 0.12 (a query-predicate API change throws inside the
    -- highlighter). `main` has a different API: there is no configs.setup{} with
    -- `highlight`/`indent` tables — those are enabled per-buffer via core
    -- `vim.treesitter`, and parsers are installed with `install()`.
    branch = "main",
    lazy = false, -- main registers its filetype handling at startup, not on demand
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      -- Parsers to keep installed. install() is async + idempotent (it skips any
      -- already present). The handle is stashed in a global so bootstrap.sh can
      -- :wait() on it during headless provisioning (main has no TSUpdateSync).
      _G.__ts_install = ts.install({
        "bash", "c", "c_sharp", "go", "java", "json", "lua", "markdown",
        "markdown_inline", "python", "rust", "toml", "vim", "vimdoc", "yaml",
      })

      -- main auto-enables nothing: start highlighting + treesitter indentation
      -- for any buffer whose filetype has an installed parser. pcall guards
      -- filetypes without a parser (e.g. one still installing asynchronously).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
