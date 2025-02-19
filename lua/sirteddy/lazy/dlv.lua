return {
  -- Core debugging engine
  { 'mfussenegger/nvim-dap' },

  -- UI for nvim-dap
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dapui = require('dapui')

      dapui.setup() -- Setup the UI

      -- Automatically open/close the UI
      local dap = require('dap')
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- Go-specific DAP setup
  {
    'leoluz/nvim-dap-go',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-go').setup()
    end,
  },

  -- Optional: Fancy UI for debugging signs (breakpoints, etc.)
  {
    'nvim-neotest/nvim-nio', -- Required by dap-ui (Neovim 0.10+)
    dependencies = { 'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui' },
  },
}
