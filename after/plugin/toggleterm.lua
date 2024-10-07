require("toggleterm").setup{
    size = 20,
    open_mapping = [[<C-t>]], -- toggle map
    shading_factor = 2,
    direction = 'float', -- Bytte denne til 'vertical' | 'horizontal' | 'tab' | 'float'
    float_opts = {
        border = 'curved',
        width = 80,
        height = 30,
    }
}

