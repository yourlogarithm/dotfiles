return {
  {
    "coffebar/neovim-project",
    lazy = false,
    priority = 100,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "Shatur/neovim-session-manager",
    },
    init = function()
      -- Save extra state in sessions (default opts already cover buffers,
      -- windows, layout, cwd, tabpages).
      vim.opt.sessionoptions:append("globals")
    end,
    opts = {
      -- Directories scanned for projects (glob, one level deep).
      projects = {
        "~/Projects/*",
        "~/.config/*",
      },
      -- Reopen the last project's session when nvim starts with no file args.
      last_session_on_startup = true,
      picker = { type = "telescope" },
    },
    keys = {
      { "<leader>fp", "<cmd>NeovimProjectDiscover<cr>", desc = "Projects (all)" },
      { "<leader>fP", "<cmd>NeovimProjectHistory<cr>", desc = "Projects (recent)" },
    },
  },
}
