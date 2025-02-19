return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        require('telescope').setup({
            defaults = {
                -- Include hidden files (dotfiles)
                file_ignore_patterns = {
                    -- Add any files or patterns you want to ignore here
                    "%.git/", -- Ignore git folders
                    "%.DS_Store", -- macOS-specific files
                    "%.jpg", "%.jpeg", "%.png", -- Example: ignoring image files
                    -- You can also add .gitlab-ci.yml here if you want to exclude it
                },
            }
        })

        local builtin = require('telescope.builtin')

        -- Custom function to find files from the project root
        local function find_files_from_project_root()
            -- Get the Git root directory
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

            -- Fallback to the current working directory if not in a Git repository
            local root_dir = git_root ~= "" and git_root or vim.fn.getcwd()

            -- Call Telescope's find_files with the determined root directory
            builtin.find_files({ cwd = root_dir, hidden = true })  -- 'hidden' option set to true
        end

        -- Override <leader>pf to use the custom function
        vim.keymap.set('n', '<leader>pf', find_files_from_project_root, {})

        -- Other mappings
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}

