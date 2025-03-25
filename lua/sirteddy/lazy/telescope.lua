return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                    "%.git/", -- ignore git folders
                    "%.ds_store", -- macos-specific files
                    "%.jpg", "%.jpeg", "%.png", -- example: ignoring image files
                },
            }
        })

        local builtin = require('telescope.builtin')

        -- custom function to find files from the project root
        local function find_files_from_project_root()
            -- get the git root directory
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

            -- fallback to the current working directory if not in a git repository
            local root_dir = git_root ~= "" and git_root or vim.fn.getcwd()

            -- call telescope's find_files with the determined root directory
            builtin.find_files({ cwd = root_dir, hidden = true })  -- 'hidden' option set to true
        end

        -- override <leader>pf to use the custom function
        vim.keymap.set('n', '<leader>pf', find_files_from_project_root, {})

        -- other mappings
        vim.keymap.set('n', '<c-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}

