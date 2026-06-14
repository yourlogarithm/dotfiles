return {
  {
    -- Maintained fork (phaazon/hop.nvim is archived).
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      { "<leader>hw", "<cmd>HopWord<cr>", mode = { "n", "v" }, desc = "Hop to word" },
      { "<leader>hc", "<cmd>HopChar2<cr>", mode = { "n", "v" }, desc = "Hop to 2 chars" },
      { "<leader>hl", "<cmd>HopLine<cr>", mode = { "n", "v" }, desc = "Hop to line" },
      { "<leader>hp", "<cmd>HopPattern<cr>", mode = { "n", "v" }, desc = "Hop to pattern" },
    },
    opts = {},
  },
}
