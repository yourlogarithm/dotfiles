-- Leader keys (must be set before lazy.nvim loads).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8

-- Soft-wrap: visually continue a long line onto the next screen row instead of
-- letting it run off-screen. This is display-only — the file on disk is never
-- modified (no hard line breaks inserted).
opt.wrap = true
opt.linebreak = true   -- break at word boundaries, not mid-word
opt.breakindent = true -- continued rows keep the line's indentation

-- Vertical ruler marking the target line length (where to break a long line).
opt.colorcolumn = "200"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Behavior
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.mouse = "a"
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true
opt.confirm = true

-- Show whitespace markers. NOTE: no `space` char here — rendering every space
-- as a dot fills the leading indent columns and suppresses indent-blankline's
-- vertical guides. `trail` still dots trailing whitespace; indent guides handle
-- the leading columns.
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Diagnostics: show the message inline to the right of the offending line,
-- sorted so errors win over warnings on the same line.
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
  severity_sort = true,
  underline = true,
})
