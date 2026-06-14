return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- stable API; the default `main` branch is a WIP rewrite
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Clone parsers via git instead of downloading tarballs: avoids the
      -- macOS "Error during tarball extraction" (fragile curl/tar shell-out).
      require("nvim-treesitter.install").prefer_git = true

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "c_sharp", "go", "java", "json", "lua", "markdown",
          "markdown_inline", "python", "rust", "toml", "vim", "vimdoc", "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
