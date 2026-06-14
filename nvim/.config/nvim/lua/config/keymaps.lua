local map = vim.keymap.set

-- Clear search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Save / quit.
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

-- Window navigation.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move selected lines.
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when jumping.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Function keys: save / close buffer.
map({ "n", "i", "v" }, "<F2>", "<cmd>write<cr>", { desc = "Save buffer" })
map("n", "<F4>", "<cmd>quit<cr>", { desc = "Quit (:q)" })
map("n", "<S-F4>", "<cmd>quit!<cr>", { desc = "Force quit (:q!)" })

-- Terminal: open in a bottom split, and an easy way out of terminal mode.
map("n", "<leader>t", "<cmd>botright split | resize 14 | terminal<cr>", { desc = "Open terminal (split)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
