return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Must not be lazy-loaded so `nvim .` opens oil instead of netrw
    lazy = false,
    opts = {
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
        },
        -- Centered float; values between 0 and 1 are a fraction of the editor size
        float = {
            max_width = 0.5,
            max_height = 0.6,
            border = "rounded",
        },
        keymaps = {
            -- Keep vim-tmux-navigator pane movement working inside oil
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-r>"] = "actions.refresh",
            ["q"] = "actions.close",
        },
    },
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        { "<leader>pv", "<cmd>Oil<cr>", desc = "Open file explorer" },
        {
            "<leader>e",
            function()
                require("oil").toggle_float()
            end,
            desc = "Toggle floating file explorer",
        },
    },
}
