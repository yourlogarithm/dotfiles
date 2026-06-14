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
    -- Tag this window as the terminal window, and remember its terminal buffer,
    -- so we can keep file buffers from being opened into it (see below).
    vim.w.term_buf = vim.api.nvim_get_current_buf()
    vim.cmd("startinsert")
  end,
})

-- Keep file buffers out of the terminal window. If a normal file is displayed
-- in the focused terminal window (e.g. clicking a bufferline tab while the
-- terminal has focus), bounce it up to a real editor window instead of letting
-- it replace the terminal.
local redirecting = false
local function win_term_buf(win)
  local ok, b = pcall(vim.api.nvim_win_get_var, win, "term_buf")
  return ok and b or nil
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("keep_files_out_of_term", { clear = true }),
  callback = function(args)
    if redirecting then return end
    local file_buf = args.buf
    if vim.bo[file_buf].buftype ~= "" or not vim.bo[file_buf].buflisted then
      return
    end
    local term_win = vim.api.nvim_get_current_win()
    local term_buf = win_term_buf(term_win)
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
      return
    end

    redirecting = true
    -- Put the terminal back in its window.
    vim.api.nvim_win_set_buf(term_win, term_buf)

    -- Find an existing editor window (normal buffer, not the terminal window).
    local editor
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local b = vim.api.nvim_win_get_buf(win)
      if win ~= term_win and not win_term_buf(win) and vim.bo[b].buftype == "" then
        editor = win
        break
      end
    end
    if editor then
      vim.api.nvim_win_set_buf(editor, file_buf)
      vim.api.nvim_set_current_win(editor)
    else
      -- No editor window yet: open one above the terminal.
      vim.cmd("topleft split")
      vim.api.nvim_win_set_buf(0, file_buf)
    end
    redirecting = false
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
