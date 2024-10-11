return {

    {
        "sho-87/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd([[colorscheme kanagawa-paper]])
        end,
    },

    --[=====[
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme catppuccin]])
        end,
    },

    --]=====]
    -- { "catppuccin/nvim", name = "catppuccin" },
    -- {"folke/tokyonight.nvim" },
    -- { "gbprod/nord.nvim" },
    -- {"sainnhe/gruvbox-material"},
    -- { "EdenEast/nightfox.nvim" },
    -- { "rebelot/kanagawa.nvim" }
}
