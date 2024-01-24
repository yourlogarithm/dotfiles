require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.ruff_lsp.setup({})


require("gitsigns").setup()

require("Comment").setup()
local ft = require("Comment.ft")
ft.set('falang', '//%s')

-- require("copilot").setup({})
require("nvim-treesitter").setup({})
require("ibl").setup({})
require("gruvbox").setup({})
require("colorizer").setup()
require("conform").setup({python={"flake8"}})
require("treesitter-context").setup()
require("nvim-treesitter.configs").setup({
    highlight={
        enable=true
    }
})
