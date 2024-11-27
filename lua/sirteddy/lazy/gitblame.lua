return {
    "f-person/git-blame.nvim",

    -- Make the plugin lazy-loaded when you toggle it
    keys = {
        { "<leader>b", ":GitBlameToggle<CR>", mode = "n" }
    },

    config = function()
        -- Disable Git blame globally (so it doesn't start on its own)
        vim.g.gitblame_enabled = 0

        -- Customize the blame format (optional)
        vim.g.gitblame_message_template = "<summary> • <date> • <author>"

        -- Delay before the blame message is displayed (in ms)
        vim.g.gitblame_delay = 500

        -- Optional: Disable virtual text
        -- vim.g.gitblame_display_virtual_text = 0

        -- Keymap to toggle Git blame (only when the plugin is loaded)
        -- The key mapping will be triggered by lazy-loading the plugin
        vim.keymap.set("n", "<leader>b", ":GitBlameToggle<CR>", { noremap = true, silent = true })
    end
}

