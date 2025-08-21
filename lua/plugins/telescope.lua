return {
    "nvim-telescope/telescope.nvim",
    disable = false,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local themes = require("telescope.themes")

        local function cursor_wrap(tele_cmd)
            return function()
                local cursor = themes.get_cursor({
                    layout_config = {
                        width = 120,
                        height = 12,
                    },
                })
                tele_cmd(cursor)
            end
        end

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>pf", builtin.git_files, { desc = "Find git files" })
        vim.keymap.set("n", "<leader>gl", builtin.live_grep, { desc = "Live grep in project" })
        vim.keymap.set("n", "<leader>gf", builtin.grep_string, { desc = "Grep word under cursor" })
        vim.keymap.set("n", "<leader>fs", cursor_wrap(builtin.current_buffer_fuzzy_find), { desc = "Fuzzy find in current buffer" })
        vim.keymap.set("n", "<leader>ld", builtin.diagnostics, { desc = "List all diagnostics" })
        vim.keymap.set("n", "<leader>lt", function()
            builtin.diagnostics({ bufnr = 0 })
        end, { desc = "List current buffer diagnostics" })
        -- list references
        vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "List LSP references" })
        vim.keymap.set("n", "<leader>lb", builtin.buffers, { desc = "List open buffers" })
        vim.keymap.set("n", "<leader>lc", builtin.commands, { desc = "List available commands" })
        vim.keymap.set("n", "<leader>lp", builtin.planets, { desc = "Show planets (Easter egg)" })

        telescope.load_extension("file_browser")
        telescope.setup({
            pickers = {
                diagnostics = {
                    theme = "dropdown",
                },
                commands = {
                    theme = "dropdown",
                },
                grep_string = {
                    theme = "dropdown",
                },
            },
        })

        vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<Enter>", { noremap = true, desc = "Open file browser" })
        vim.keymap.set(
            "n",
            "<leader>ll",
            ":Telescope file_browser path=%:p:h select_buffer=true <Enter>",
            { noremap = true, desc = "Open file browser at current file location" }
        )
    end,
}
