return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp", -- show LSP error/warn badges on tabs
        -- Close a tab without killing its window / quitting nvim.
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", separator = true },
        },
      },
    },
    keys = {
      -- Cycle tabs (VSCode-style). Both Shift-h/l and [b/]b provided.
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer/tab" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer/tab" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer/tab" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer/tab" },
      -- Reorder the current tab (drag isn't possible in a terminal).
      { "<leader>b,", "<cmd>BufferLineMovePrev<cr>", desc = "Move tab left" },
      { "<leader>b.", "<cmd>BufferLineMoveNext<cr>", desc = "Move tab right" },
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Close buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin/unpin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
    },
  },
}
