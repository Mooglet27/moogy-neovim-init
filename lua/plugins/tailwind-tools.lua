return {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        document_color = {
            enabled = true, -- can be toggled by commands
            kind = "inline", -- "inline" | "foreground" | "background"
            inline_symbol = "󰝤 ", -- only used in inline mode
            debounce = 300, -- in milliseconds, only applied in insert mode
        },
        conceal = {
            enabled = false, -- can be toggled by commands
            min_length = nil, -- only conceal classes exceeding the provided length
            symbol = "󱏿", -- only a single character is allowed
            highlight = { -- extmark highlight options, see :h 'highlight'
                fg = "#38BDF8",
            },
        },
    },
    keys = {
        {
            "<leader>th",
            "<cmd>TailwindConcealToggle<cr>",
            desc = "Toggle Tailwind Conceal",
        },
    },
}
