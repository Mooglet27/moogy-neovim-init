return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    opts = {
        enhanced_diff_hl = true,
    },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview working tree" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview current file history" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview branch history" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
}
