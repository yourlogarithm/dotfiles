-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Terminal buffers: drop the gutter/numbers and start in insert mode.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("term_open", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.bo.buflisted = false -- keep terminals out of the bufferline tabs
    vim.cmd("startinsert")
  end,
})

-- Default IDE layout when a project/session is opened: file tree on the left
-- and a terminal at the bottom, keeping focus in the editor.
local function open_ide_layout()
  local has_term = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      has_term = true
      break
    end
  end
  if not has_term then
    vim.cmd("botright 14split | terminal")
    vim.cmd("wincmd p") -- keep focus in the editor window
  end
  pcall(vim.cmd, "Neotree show left") -- `show` reveals without stealing focus
end

vim.api.nvim_create_autocmd("User", {
  pattern = "SessionLoadPost",
  group = vim.api.nvim_create_augroup("ide_layout", { clear = true }),
  callback = function()
    vim.schedule(open_ide_layout)
  end,
})

-- Remove trailing whitespace on save is left to formatters (conform.nvim).
