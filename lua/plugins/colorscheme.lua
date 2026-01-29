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
    --[=====[
    {
        "gbprod/nord.nvim",
        name = "nord",
        config = function()
            vim.cmd([[colorscheme nord]])
        end,
    },
    --]=====]

    --[=====[
    {
        "sainnhe/gruvbox-material",
        name = "gruvbox",
        config = function()
            vim.cmd([[colorscheme gruvbox-material]])
        end,
    },
    --[=====[
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
        config = function()
            vim.cmd([[colorscheme nightfox]])
        end,
    },
    --]=====]
    -- { "rebelot/kanagawa.nvim" }
}
