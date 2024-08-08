-- ~/.config/nvim/lua/sirteddy/tflint.lua


-- Auto-format Terraform files on save and show errors if any
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.tf",
  callback = function()
    local file = vim.fn.expand('%')
    local result = vim.fn.system('terraform fmt ' .. file)
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln('terraform fmt error:\n' .. result)
    end
  end
})


-- Auto-format JSON files on save and show errors if any
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    local file = vim.fn.expand('%:p')
    local result = vim.fn.system('jq . ' .. file)
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln('jq error:\n' .. result)
    else
      vim.cmd('%!jq .')
    end
  end
})
