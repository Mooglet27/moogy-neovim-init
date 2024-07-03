return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "vim",
                "python",
                "rust",
                "sql",
                "html",
                "javascript",
                "typescript",
                "tsx",
                "json",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            -- Automatically install missing parseres when entering buffer
            auto_install = true,
        })
    end,
}
