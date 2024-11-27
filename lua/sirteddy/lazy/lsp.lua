return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "plenary.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },

    config = function()
        -- Setting up the LSP completion capabilities
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        capabilities.offsetEncoding = { "utf-8", "utf-16" } -- Add UTF-8 support globally

        -- Setup for the fidget plugin (showing LSP progress)
        require("fidget").setup({})

        -- Mason setup for handling LSP servers
        require("mason").setup()

        -- Mason-LSPConfig setup
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",           -- Lua Language Server
                "rust_analyzer",    -- Rust Language Server
                "tsserver",         -- TypeScript/JavaScript Server
                "terraform-ls",
            },
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        settings = {
                            terraform = {
                                semanticTokens = false, -- Explicitly disable semantic tokens
                            },
                        },
                        on_attach = function(client)
                            -- Forcefully remove semantic tokens support if `terraform-ls` ignores settings
                            client.server_capabilities.semanticTokensProvider = nil
                        end,                    }
                end,

                -- Custom handler for lua_ls
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                -- Custom handler for terraform-ls
                ["terraform-ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup {
                        capabilities = capabilities,
                        settings = {
                            terraform = {
                                -- Disable semantic tokens if problematic
                                semanticTokens = false,
                            }
                        }
                    }
                end,
            }
        })

        -- Completion setup using nvim-cmp
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For luasnip users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users
            }, {
                { name = 'buffer' },
            })
        })

        -- Diagnostic configuration (floating windows)
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- Null-ls setup for various formatters and linters
        local null_ls = require("null-ls")

        null_ls.setup({
            autostart = true,
            debug = true,  -- Enable debugging for better logging
            sources = {
                null_ls.builtins.diagnostics.markdownlint,
                null_ls.builtins.diagnostics.golangci_lint,
                null_ls.builtins.diagnostics.staticcheck,
                null_ls.builtins.formatting.goimports,
                null_ls.builtins.code_actions.gomodifytags,
                null_ls.builtins.diagnostics.jsonlint,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.jq,
                null_ls.builtins.diagnostics.revive,
                null_ls.builtins.diagnostics.shellcheck,
                null_ls.builtins.formatting.terraform_fmt,
            },
            on_attach = function(client, bufnr)
                print("Attached null-ls to buffer " .. bufnr)  -- Debug message to confirm attachment

                -- Set working directory to the project's root
                local function set_root_dir()
                    local root_patterns = { "go.mod", "main.go" }
                    local dir = vim.fn.expand("%:p:h") -- Start from the file's directory
                    for _, pattern in ipairs(root_patterns) do
                        local root_dir = vim.fn.findfile(pattern, dir .. ";") -- Look upwards for go.mod/main.go
                        if root_dir and root_dir ~= "" then
                            vim.fn.chdir(vim.fn.fnamemodify(root_dir, ":h"))
                            break
                        end
                    end
                end

                set_root_dir()  -- Automatically set working directory to the project's root

                -- Format on save - globally applied to all relevant file types
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
                    pattern = { "*.go", "*.json", "*.md", "*.tf" },  -- Adjust based on your file types
                    callback = function()
                        vim.lsp.buf.format({ async = false })  -- Format synchronously on save
                    end,
                })
            end,
        })
    end
}

