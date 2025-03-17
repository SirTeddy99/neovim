-- vimwiki.lua
return {
    "vimwiki/vimwiki",  -- Specify Vimwiki plugin

    config = function()
        -- Set up Vimwiki configuration
        vim.g.vimwiki_list = {
            {
                path = vim.fn.expand("~/Documents/obsidian_job"),  -- Correctly expand the `~`
                syntax = "markdown",       -- Use markdown syntax
                ext = ".md",               -- Files are saved as Markdown
                auto_toc = 1,              -- Automatically generate table of contents
                diary_rel_path = "Daily",  -- Store daily notes in the "Daily" folder
            }
        }

        -- Make sure to clear any default directories that might be set
        vim.g.vimwiki_dir = vim.fn.expand("~/Documents/obsidian_job")  -- Ensure Vimwiki is pointed to the right directory

        -- Keybindings for Vimwiki functionality
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<leader>ww", ":VimwikiIndex<CR>", opts)  -- Open Vimwiki index
        vim.api.nvim_set_keymap("n", "<leader>wn", ":VimwikiMakeDiaryNote<CR>", opts)  -- Create a new daily note
        vim.api.nvim_set_keymap("n", "<leader>wt", ":VimwikiTable<CR>", opts)  -- Create a table in the current file
    end
}

