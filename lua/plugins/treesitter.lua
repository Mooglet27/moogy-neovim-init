return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
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
                "java",
            },
            sync_install = false,
            -- markdown disabled: nvim-treesitter's frozen master branch crashes
            -- (query_predicates.lua set-lang-from-info-string!) on fenced code
            -- blocks against current Neovim; falls back to regex highlighting.
            highlight = { enable = true, disable = { "dockerfile", "markdown" } },
            indent = { enable = true, disable = { "python" } },
            -- Automatically install missing parseres when entering buffer
            auto_install = true,
            additional_vim_regex_highlighting = { "dockerfile" },
        })
    end,
}
