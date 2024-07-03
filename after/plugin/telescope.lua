local builtin = require("telescope.builtin")
local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local open_with_trouble = require("trouble.sources.telescope").open

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>pf", builtin.git_files, {})
vim.keymap.set("n", "<leader>gf", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>fg", builtin.grep_string, {})
vim.keymap.set("n", "<leader>fs", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>ld", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>lt", function()
	builtin.diagnostics({ bufnr = 0 })
end, {})
-- list references
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>lb", builtin.buffers, {})
vim.keymap.set("n", "<leader>lc", builtin.commands, {})

telescope.load_extension("file_browser")
telescope.setup({
	extensions = {
		file_browser = {
			-- theme = "ivy",
			-- hijack_netrw = true,
		},
	},
	pickers = {
		current_buffer_fuzzy_find = {
			theme = "ivy",
		},
	},
})
vim.api.nvim_set_keymap("n", "<space>fb", ":Telescope file_browser<Enter>", { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<space>ll",
	":Telescope file_browser path=%:p:h select_buffer=true <Enter>",
	{ noremap = true }
)
