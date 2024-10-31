-- Lualine setup with unsaved changes indicator
require('lualine').setup({
  options = {
    theme = 'auto',         -- Automatically picks a color theme based on your colorscheme
    section_separators = '', -- Customize as per preference
    component_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      {
        'filename',
        path = 1,              -- Display the relative file path
      },
      {
        function() 
          return vim.bo.modified and '✗' or ''  -- '✗' indicates unsaved changes
        end,
        cond = function() 
          return vim.bo.modified -- Show the indicator only when modified
        end,
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
