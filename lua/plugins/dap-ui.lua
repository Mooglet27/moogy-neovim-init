-- nvim-dap itself is pulled in by nvim-java; this adds the UI and keymaps on top
return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()

        -- Open the UI when a session starts and close it when the session ends
        dap.listeners.before.attach.dapui_config = dapui.open
        dap.listeners.before.launch.dapui_config = dapui.open
        dap.listeners.before.event_terminated.dapui_config = dapui.close
        dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
    -- `<leader>d` is already black-hole delete, so debug maps live on F-keys and `<leader>b`/`<leader>D*`
    keys = {
        { "<F5>", function() require("dap").continue() end, desc = "Debug: start/continue" },
        { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
        { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
        { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
        { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
        {
            "<leader>B",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Debug: conditional breakpoint",
        },
        { "<leader>Du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
        {
            "<leader>De",
            function() require("dapui").eval() end,
            mode = { "n", "v" },
            desc = "Debug: evaluate expression",
        },
    },
}
