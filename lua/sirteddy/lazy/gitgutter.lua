return {
    {
        "airblade/vim-gitgutter",
        lazy = false, -- Load on startup
        config = function()
            -- Enable GitGutter signs
            vim.g.gitgutter_enabled = 1

            -- Enable live preview for changes
            vim.g.gitgutter_map_keys = 0 -- Disable default key mappings

            -- Keymaps for GitGutter actions
            vim.keymap.set("n", "<leader>hp", ":GitGutterPreviewHunk<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>hs", ":GitGutterStageHunk<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>hu", ":GitGutterUndoHunk<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>hn", ":GitGutterNextHunk<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>hp", ":GitGutterPrevHunk<CR>", { noremap = true, silent = true })
        end
    },
}

