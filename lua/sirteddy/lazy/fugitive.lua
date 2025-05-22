return {
	"tpope/vim-fugitive",
	config = function()
		-- Default Git command mapping
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		-- Create an autogroup for Fugitive
		local SirTeddy_Fugitive = vim.api.nvim_create_augroup("SirTeddy_Fugitive", {})

		-- Create an autocommand for Fugitive buffers
		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = SirTeddy_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

				-- Git push with tracking branch
				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
			end,
		})

		-- Diffget mappings
		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

		-- Keybinding for switching to 'main' and pulling (<leader>gm)
		vim.keymap.set(
			"n",
			"<leader>gm",
			":Git checkout main | Git pull --ff-only<CR>",
			{ noremap = true, silent = true }
		)

		-- Keybinding for fetching 'main' and mergin in branch (<leader>fm)
		vim.keymap.set("n", "<leader>gu", ":!git fetch && git merge origin/main<CR>", { noremap = true, silent = true })

		vim.keymap.set("n", "<leader>gp", function()
			vim.cmd(
				'Git push -o merge_request.create -o merge_request.assign="@TorEdvard.Roysland" -o merge_request.ready'
			)
		end, { desc = "GitLab MR Push" })
	end,
}
