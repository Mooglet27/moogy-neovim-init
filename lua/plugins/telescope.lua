local function builtin(name, opts)
    return function()
        require("telescope.builtin")[name](opts)
    end
end

local function cursor_wrap(name)
    return function()
        local cursor = require("telescope.themes").get_cursor({
            layout_config = {
                width = 120,
                height = 12,
            },
        })
        require("telescope.builtin")[name](cursor)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
        { "<leader>ff", builtin("find_files"), desc = "Find files" },
        { "<leader>fo", builtin("oldfiles", { cwd_only = true }), desc = "Recent files in project" },
        { "<leader>fr", builtin("resume"), desc = "Resume last picker" },
        { "<leader>pf", builtin("git_files"), desc = "Find git files" },
        { "<leader>gl", builtin("live_grep"), desc = "Live grep in project" },
        { "<leader>gf", builtin("grep_string"), desc = "Grep word under cursor" },
        { "<leader>fs", cursor_wrap("current_buffer_fuzzy_find"), desc = "Fuzzy find in current buffer" },
        { "<leader>ld", builtin("diagnostics"), desc = "List all diagnostics" },
        { "<leader>lt", builtin("diagnostics", { bufnr = 0 }), desc = "List current buffer diagnostics" },
        { "<leader>lr", builtin("lsp_references"), desc = "List LSP references" },
        { "<leader>lb", builtin("buffers"), desc = "List open buffers" },
        { "<leader>lc", builtin("commands"), desc = "List available commands" },
        { "<leader>lp", builtin("planets"), desc = "Show planets (Easter egg)" },
        { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "Open file browser" },
        {
            "<leader>ll",
            "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
            desc = "Open file browser at current file location",
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "filename_first" },
                mappings = {
                    i = {
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    file_ignore_patterns = { "^.git/" },
                },
                buffers = {
                    sort_mru = true,
                    mappings = {
                        i = { ["<C-d>"] = actions.delete_buffer },
                    },
                },
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
            extensions = {
                file_browser = {
                    hidden = true,
                    grouped = true,
                    -- oil.nvim replaces netrw
                    hijack_netrw = false,
                },
            },
        })

        -- Extensions must load after setup so their config is picked up
        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")
    end,
}
