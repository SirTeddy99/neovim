-- ~/.config/nvim/lua/sirteddy/tflint.lua


-- Auto-format Terraform files on save and show errors if any
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.tf", "**/*.tf"},
  callback = function()
    -- Temporarily disable file change detection events
    vim.opt.eventignore = "FileChangedShell"

    local file = vim.fn.expand('%')
    local result = vim.fn.system('terraform fmt ' .. file)

    -- Re-enable file change detection events
    vim.opt.eventignore = ""

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

-- Auto-format Go files on save and show errors if any
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.go"},
  callback = function()
    -- Temporarily disable file change detection events
    vim.opt.eventignore = "FileChangedShell"

    local file = vim.fn.expand('%')
    local result = vim.fn.system('gofmt -w ' .. file)

    -- Re-enable file change detection events
    vim.opt.eventignore = ""

    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln('gofmt error:\n' .. result)
    end
  end
})
