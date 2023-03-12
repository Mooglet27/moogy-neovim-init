local builtin = require('telescope.builtin')
local tele = require('telescope')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>gf', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end) 

tele.setup {
    extensions = {
        file_browser = {
            -- theme = "ivy",
            hijack_netrw = true,
        },
    },
}
tele.load_extension("file_browser")

vim.api.nvim_set_keymap("n",
    "<space>fb",
    ":Telescope file_browser<Enter>",
    { noremap = true }
)
vim.api.nvim_set_keymap("n",
    "<space>fbh",
    ":Telescope file_browser path=%:p:h select_buffer=true <Enter>",
    { noremap = true }
)

