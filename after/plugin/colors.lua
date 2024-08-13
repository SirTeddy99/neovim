-- Configure Terrafox
require('nightfox').setup({
  options = {
    -- Add your configuration options here
    transparent = true,     -- Enable transparent background
    styles = {
      comments = "italic",  -- Make comments italic
      keywords = "bold",    -- Make keywords bold
      functions = "italic,bold", -- Make functions italic and bold
      strings = "NONE",     -- No special styling for strings
      variables = "NONE",   -- No special styling for variables
    },
    -- Other options like terminal colors, inverse, etc.
  }
})

function ColorMyPencils(color)
    color = color or "rose-pine"  -- Default to "rose-pine" if no color is provided
    vim.cmd.colorscheme(color)    -- Set the color scheme

    -- Set highlights with transparent backgrounds
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Automatically set color scheme on VimEnter
vim.cmd([[autocmd VimEnter * lua ColorMyPencils()]])

-- Function to toggle between "rose-pine" and "terrafox"
function ToggleColorScheme()
    local current_scheme = vim.g.colors_name  -- Get the current color scheme name
    if current_scheme == "rose-pine" then
        ColorMyPencils("terrafox")
    else
        ColorMyPencils("rose-pine")
    end
end

-- Create a Vim command to toggle color schemes
vim.cmd([[command! ToggleColor lua ToggleColorScheme()]])

-- Bind <leader>cs to toggle between color schemes
vim.api.nvim_set_keymap("n", "<leader>cs", ":ToggleColor<CR>", { noremap = true, silent = true })
