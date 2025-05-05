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
		"nvimtools/none-ls.nvim",
	},

	config = function()
		-- Setting up the LSP completion capabilities
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
		capabilities.offsetEncoding = { "utf-8", "utf-16" } -- Add UTF-8 support globally

		-- Setup for the fidget plugin (showing LSP progress)
		require("fidget").setup({})

		-- Mason setup for handling LSP servers
		require("mason").setup()

		-- Mason-LSPConfig setup
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls", -- Lua Language Server
				"gopls", -- Go Language Server
				"terraformls", -- Terraform Language Server (correct)
				"tflint",
			},
			handlers = {
				-- Default handler for all servers
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						settings = {
							terraform = {
								semanticTokens = false, -- Explicitly disable semantic tokens
							},
						},
						on_attach = function(client)
							-- Forcefully remove semantic tokens support if `terraform-ls` ignores settings
							client.server_capabilities.semanticTokensProvider = nil
						end,
					})
				end,

				-- Custom handler for lua_ls
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
				-- Custom handler for terraform-ls
				["terraformls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.terraformls.setup({
						capabilities = capabilities,
						settings = {
							terraform = {
								-- Disable semantic tokens if problematic
								semanticTokens = false,
							},
						},
					})
				end,
				-- Custom handler for gopls
				["gopls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								analyses = {
									unusedparams = true, -- Enable unused parameter analysis
								},
								staticcheck = true, -- Enable staticcheck
								gofumpt = true, -- Enable gofumpt formatting
								usePlaceholders = true, -- Enable placeholders in Go for struct tags
							},
						},
					})
				end,
			},
		})

		-- Completion setup using nvim-cmp
		local luasnip = require("luasnip")
		-- Setup nvim-cmp for autocompletion
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- Use LuaSnip for expanding snippets
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(), -- Select next item
				["<C-p>"] = cmp.mapping.select_prev_item(), -- Select previous item
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
				["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP completion
				{ name = "luasnip" }, -- Snippets (LuaSnip)
				{ name = "path" }, -- Path completion (file and directory)
			}, {
				{ name = "buffer" }, -- Completion from buffer
			}),
		})
		luasnip.add_snippets("go", {
			luasnip.snippet("iferr", {
				luasnip.text_node({
					"if err != nil {",
					'\tlog.Fatalln("error happens...", err)',
					"}",
				}),
			}),
		})
		luasnip.add_snippets("go", {
			luasnip.snippet("startmain", {
				luasnip.text_node({
					"// Package main is used for...",
					"package main",
					" ",
					'import "fmt"',
					" ",
					"func main() {",
					'\tfmt.Println("Hello")',
					"}",
				}),
			}),
		})

		-- Optionally, configure LuaSnip (e.g., for snippets from files)
		require("luasnip.loaders.from_vscode").lazy_load() -- Load VSCode-style snippets

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
			debug = true, -- Enable debugging for better logging
			sources = {
				null_ls.builtins.diagnostics.markdownlint.with({
					filetypes = { "markdown", "vimwiki" }, -- Add "vimwiki" support
				}),
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.diagnostics.staticcheck,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.code_actions.gomodifytags,
				null_ls.builtins.diagnostics.revive,
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.diagnostics.shellcheck,
				null_ls.builtins.formatting.shfmt,
				-- null_ls.builtins.diagnostics.jsonlint,
				-- null_ls.builtins.formatting.jq,
				null_ls.builtins.formatting.prettier,
			},
			on_attach = function(client, bufnr)
				print("Attached null-ls to buffer " .. bufnr) -- Debug message to confirm attachment

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

				set_root_dir() -- Automatically set working directory to the project's root

				-- Format on save - globally applied to all relevant file types
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
					pattern = { "*.go", "*.json", "*.md", "*.tf", "*.sh", "*.lua" }, -- Adjust based on your file types
					callback = function()
						vim.lsp.buf.format({ async = false }) -- Format synchronously on save
					end,
				})
			end,
		})
	end,
}
