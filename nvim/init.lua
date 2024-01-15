local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "ellisonleao/gruvbox.nvim",
    "neovim/tree-sitter-vimdoc",
    "zbirenbaum/copilot.lua",
    "nvim-treesitter/nvim-treesitter",
    "lukas-reineke/indent-blankline.nvim",
    {"numToStr/Comment.nvim", opt={}, lazy=false},
    "lewis6991/gitsigns.nvim",
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "NvChad/nvim-colorizer.lua",
    "stevearc/conform.nvim",
    "nvim-treesitter/nvim-treesitter-context",
    "preservim/nerdtree",
    "lambdalisue/suda.vim",
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    "ryanoasis/vim-devicons",
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    "Fymyte/rasi.vim"
})


require("plugins")
require("options")
require("mappings")
