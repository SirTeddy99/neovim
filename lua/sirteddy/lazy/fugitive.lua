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
                local opts = {buffer = bufnr, remap = false}

                -- Git push command
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                -- Git pull with rebase
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, opts)

                -- Git push with tracking branch
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })

        -- Diffget mappings
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

        -- Keybinding for switching to 'main' and pulling (Ctrl+M)
        vim.keymap.set("n", "<C-M>", ':Git fetch && Git checkout main && Git pull --rebase=interactive<CR>', { noremap = true, silent = true })
    end
}

