-- Set cursor to block in normal mode and vertical bar in insert mode
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
-- vim.opt.guicursor = ""

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

vim.opt.clipboard:append('unnamedplus')

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = ""

vim.opt.cursorline = true
-- Highlight current line number
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })


-----------------------------------
-- Comment setup
-----------------------------------

-- Set commentstring for Terraform files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.bo.commentstring = "# %s"
  end
})

vim.api.nvim_set_keymap('v', '<leader>q', [[:s/^/“/<CR>gv:s/$/“,<CR>]], { noremap = true, silent = true })
<<<<<<< HEAD
=======

>>>>>>> 3ed071e (Yeet)
