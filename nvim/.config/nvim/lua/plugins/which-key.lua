return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>?", function() require("which-key").show() end, desc = "Cheatsheet (all keymaps)" },
    },
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>h", group = "hop" },
        { "<leader>b", group = "buffer" },
        { "<leader>a", group = "AI/Claude" },
      },
    },
  },
}
