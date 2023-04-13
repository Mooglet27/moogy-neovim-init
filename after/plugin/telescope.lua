local builtin = require('telescope.builtin')
local tele = require('telescope')
local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gf', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>la', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ld', function()
    builtin.diagnostics({bufnr = 0})
end, {})
-- list references
vim.keymap.set('n', '<leader>lr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>lb', builtin.buffers, {})

tele.setup {
    extensions = {
        file_browser = {
            -- theme = "ivy",
            hijack_netrw = true,
        },
    },
}
tele.load_extension("file_browser")
tele.load_extension("harpoon")
vim.api.nvim_set_keymap("n",
    "<space>fb",
    ":Telescope file_browser<Enter>",
    { noremap = true }
)
vim.api.nvim_set_keymap("n",
    "<space>ll",
    ":Telescope file_browser path=%:p:h select_buffer=true <Enter>",
    { noremap = true }
)

