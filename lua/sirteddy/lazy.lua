-- Initialize Lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup({

    -- Lazy.nvim manages itself
    { "folke/lazy.nvim" },

    -- Surround plugin
    { "tpope/vim-surround" },

    -- Null-ls for LSP-like functionality
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Telescope with dependencies
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Rose-pine colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
            })
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.cmd("colorscheme rose-pine")
                end,
            })
        end,
    },

    -- Treesitter with playground and updates
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/playground" },
    },

    -- Other plugins
    { "theprimeagen/harpoon" },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    { "airblade/vim-gitgutter" },
    { "APZelos/blamer.nvim" },
    { "EdenEast/nightfox.nvim" },

    -- Lualine with optional icons
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Autoformat
    { "Chiel92/vim-autoformat" },

    -- ToggleTerm
    {
        "akinsho/toggleterm.nvim",
        version = "*",
    },

    -- LSP Zero with dependencies
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    },
})
