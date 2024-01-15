vim.o.showmatch = true
vim.o.ignorecase = true
vim.o.mouse = 'v'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.tabstop = 4 
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.wo.number = true
vim.o.wildmode = 'longest,list'
vim.o.colorcolumn = '80'
vim.cmd 'filetype plugin indent on'
vim.cmd 'syntax on'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.cmd 'filetype plugin on'
vim.wo.cursorline = true
vim.o.ttyfast = true
vim.cmd "colorscheme gruvbox"
vim.o.encoding = 'utf-8'

vim.api.nvim_command('au BufRead,BufNewFile *.falang set filetype=falang')
vim.api.nvim_command('au BufRead,BufNewfile *.smali set filetype=smali')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
