-- ~/.config/nvim/lua/sirteddy/tflint.lua


-- Automatically format JSON, Terraform, and Go files after saving
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.json", "*.tf", "*.go" },
  callback = function()
    local filetype = vim.bo.filetype
    if filetype == "json" then
      vim.cmd("silent !prettier --write %")
    elseif filetype == "terraform" then
      vim.cmd("silent !terraform fmt %")
    elseif filetype == "go" then
      vim.cmd("silent !gofmt -w %")
    end
  end,
})
