return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            transparent_bg = true,
            options = {
                show_source = {
                    enabled = true,
                    if_many = true,
                },
            },
        })
        vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
    end,
}
