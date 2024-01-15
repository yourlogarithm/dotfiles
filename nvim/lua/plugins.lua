require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.pyright.setup({})


require("gitsigns").setup()
require("Comment").setup()
require("copilot").setup({})
require("nvim-treesitter").setup({})
require("ibl").setup({})
require("gruvbox").setup({})
require("colorizer").setup()
require("conform").setup({
    python={"flake8"}
})
require("treesitter-context").setup()
