return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        max_lines = 3,
        multiline_threshold = 1,
    },
    keys = {
        {
            "[C",
            function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "Jump to enclosing context",
        },
        { "<leader>tc", "<cmd>TSContext toggle<cr>", desc = "Toggle treesitter context" },
    },
}
