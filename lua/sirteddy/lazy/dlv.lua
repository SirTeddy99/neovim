return {
  -- Core debugging engine
  { 'mfussenegger/nvim-dap' },

  -- UI for nvim-dap
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dapui = require('dapui')
      local dap = require('dap')

      dapui.setup({
        layouts = {
          {
            elements = {
              "scopes",      -- Shows locals
              "breakpoints", -- Shows active breakpoints
              "stacks",      -- Shows threads (call stack)
              "watches",     -- Allows adding watch expressions
            },
            size = 40, -- Adjusts the width of the left panel
            position = "left", -- Places all these elements on the left side
          },
          {
            elements = {
              "repl",    -- Keep REPL for debugging commands
              -- "console", -- Keep console output
            },
            size = 10, -- Adjusts the height of the bottom panel
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" }, -- Allows closing floating windows easily
          },
        },
      })

      -- Automatically open/close the UI
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

  -- Delve Go Debugging Keymaps
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      local dap_go = require('dap-go')

      vim.keymap.set('n', '<leader>1', function() dap.continue() end)
      vim.keymap.set('n', '<leader>7', function() dap.step_over() end)
      vim.keymap.set('n', '<leader>8', function() dap.step_into() end)
      vim.keymap.set('n', '<leader>9', function() dap.step_out() end)
      vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
      vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
      vim.keymap.set('n', '<Leader>dt', function() dap_go.debug_test() end) -- Debug Go test
    end,
  },
}

