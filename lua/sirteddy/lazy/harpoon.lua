return {
  "ThePrimeagen/harpoon",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup {
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
        mark_branch = false,
      },
    }

    -- Set root to Git root if possible
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.fn.isdirectory(git_root) == 1 then
          vim.cmd("cd " .. git_root)
        end
      end,
    })
  end,
  keys = {
    { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" },
    { "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
    { "<C-h>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon buffer 1" },
    { "<C-j>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon buffer 2" },
    { "<C-k>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon buffer 3" },
    { "<C-l>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon buffer 4" },
  },
}

