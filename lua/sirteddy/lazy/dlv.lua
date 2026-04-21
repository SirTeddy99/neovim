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

  -- Adapters, configurations, and keymaps
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      local dap_go = require('dap-go')

      -- netcoredbg adapter (C#)
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local dll = vim.fn.glob(cwd .. "/bin/Debug/**/**.dll", false, true)
            if #dll == 1 then
              return dll[1]
            end
            return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      vim.keymap.set('n', '<leader>1', function() dap.continue() end)
      vim.keymap.set('n', '<leader>7', function() dap.step_over() end)
      vim.keymap.set('n', '<leader>8', function() dap.step_into() end)
      vim.keymap.set('n', '<leader>9', function() dap.step_out() end)
      vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, { desc = "Start/Continue debug" })
      vim.keymap.set('n', '<Leader>di', function() dap.step_into() end, { desc = "Step into" })
      vim.keymap.set('n', '<Leader>do', function() dap.step_over() end, { desc = "Step over" })
      vim.keymap.set('n', '<Leader>dO', function() dap.step_out() end, { desc = "Step out" })
      vim.keymap.set('n', '<Leader>dx', function() dap.terminate() end, { desc = "Terminate debug" })
      vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = "Toggle DAP UI" })
      vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
      vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
      vim.keymap.set('n', '<Leader>dt', function() dap_go.debug_test() end) -- Debug Go test
    end,
  },
}

