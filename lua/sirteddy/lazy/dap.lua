return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()

        -- Auto open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- netcoredbg adapter
        dap.adapters.coreclr = {
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
            args = { "--interpreter=vscode" },
        }

        -- C# debug configuration
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch",
                request = "launch",
                program = function()
                    -- Tries to find the DLL automatically, or prompts you
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

        -- Keymaps
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue debug" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
        vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
        vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
        vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart debug" })
        vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate debug" })
        vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    end,
}
