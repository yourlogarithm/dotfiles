return {
  {
    -- Scrollbar on the right edge with marks for diagnostics, search and cursor
    -- (VSCode-style overview ruler).
    "petertriho/nvim-scrollbar",
    main = "scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
