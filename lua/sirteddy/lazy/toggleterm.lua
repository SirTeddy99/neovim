return {
    "akinsho/toggleterm.nvim", -- Ensure correct plugin name
    version = "*", -- Optional: Specify the version or use latest
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<C-t>]], -- Keymap to toggle the terminal
            shading_factor = 2,
            direction = 'float', -- Options: 'vertical', 'horizontal', 'tab', 'float'
            float_opts = {
                border = 'curved',
                width = 80,
                height = 30,
            }
        })
    end,
}

