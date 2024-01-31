require("lazy").setup({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "ellisonleao/gruvbox.nvim",
    "neovim/tree-sitter-vimdoc",
    "zbirenbaum/copilot.lua",
    "nvim-treesitter/nvim-treesitter",
    "lukas-reineke/indent-blankline.nvim",
    { "numToStr/Comment.nvim", opt = {}, lazy = false },
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
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'BurntSushi/ripgrep',
            'sharkdp/fd'
        }
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
    },
    "mfussenegger/nvim-dap",
    {
        "phaazon/hop.nvim",
        branch = 'v2'
    },
})


require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.ruff_lsp.setup({})
lspconfig.pyright.setup({
    settings = {
        python = {
            pythonPath = '/usr/bin/python3.12'
        }
    }
})


require("gitsigns").setup()

require("Comment").setup()
local ft = require("Comment.ft")
ft.set('falang', '//%s')

-- require("copilot").setup({})
require("nvim-treesitter").setup({})
require("ibl").setup({})
require("gruvbox").setup({})
require("colorizer").setup()
require("conform").setup({ python = { "flake8" } })
require("treesitter-context").setup()
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
    }
})

local cmp = require("cmp")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" }, -- For luasnip users.
        -- { name = "orgmode" },
    }, {
        { name = "buffer" },
        { name = "path" },
    }),
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

require("hop").setup({
    quit_key = '<SPC>',
    keys = 'etovxqpdygfblzhckisuran'
})

require('telescope').setup {
    pickers = {
        find_files = {
            hidden = true,
            mappings = {
                n = {
                    ["cd"] = function(prompt_bufnr)
                        local selection = require("telescope.actions.state").get_selected_entry()
                        local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                        require("telescope.actions").close(prompt_bufnr)
                        vim.cmd(string.format("silent lcd %s", dir))
                    end
                }
            }
        }
    }
}
