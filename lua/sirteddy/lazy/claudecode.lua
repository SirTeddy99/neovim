return {
    "coder/claudecode.nvim",
    dependencies = { "plenary" },
    config = function()
        require("claudecode").setup({})

        -- Toggle Claude Code terminal
        vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
        vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude Code" })
        vim.keymap.set("n", "<leader>cr", "<cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude Code" })
        vim.keymap.set("n", "<leader>cC", "<cmd>ClaudeCode --continue<CR>", { desc = "Continue last Claude session" })
        vim.keymap.set("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude model" })

        -- Context management
        vim.keymap.set("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", { desc = "Add current buffer to Claude" })
        vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })

        -- Diff handling (when Claude proposes edits)
        vim.keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude diff" })
        vim.keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })

        -- File-tree integration: from netrw/fugitive/etc., send file to Claude
        local SirTeddy_ClaudeCode = vim.api.nvim_create_augroup("SirTeddy_ClaudeCode", {})
        vim.api.nvim_create_autocmd("FileType", {
            group = SirTeddy_ClaudeCode,
            pattern = { "netrw", "oil", "NvimTree", "neo-tree", "minifiles" },
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false, desc = "Add file from tree to Claude" }
                vim.keymap.set("n", "<leader>cs", "<cmd>ClaudeCodeTreeAdd<CR>", opts)
            end,
        })
    end,
}
