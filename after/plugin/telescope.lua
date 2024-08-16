local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

-- Keybinding to find files, including hidden files but excluding .git directory
vim.keymap.set('n', '<leader>pf', function()
  builtin.find_files({
    hidden = true,
    file_ignore_patterns = { ".git/" }  -- Exclude .git directory
  })
end, {})

-- Keybinding to find git files (no changes needed here)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Keybinding to grep string with user input, including hidden files but excluding .git directory
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string(themes.get_dropdown({
    search = vim.fn.input("Grep > "),
    hidden = true,
    file_ignore_patterns = { ".git/" }  -- Exclude .git directory
  }))
end)
