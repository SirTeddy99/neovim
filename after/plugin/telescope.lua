local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


-- Keybinding to find files, including hidden files but excluding .git directory
vim.keymap.set('n', '<leader>p.', function()
  builtin.find_files({
    hidden = true,
    file_ignore_patterns = { ".git/" }  -- Exclude .git directory
  })
end, {})
