local util = require("formatter.util")

local clangd_cmd = function()
	return {
		exe = "clang-format",
		args = {
			'--style="{BasedOnStyle: Google, IndentWidth: 4}"',
			"-assume-filename",
			util.escape_path(util.get_current_buffer_file_name()),
		},
		stdin = true,
		try_node_modules = true,
	}
end

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		python = {
			require("formatter.filetypes.python").black,
			function()
				return {
					exe = "isort",
					args = {
						"-q",
						"--profile",
						"black",
						"--filename",
						util.escape_path(util.get_current_buffer_file_path()),
						"-",
					},
					stdin = true,
				}
			end,
		},
		cpp = { clangd_cmd },
		c = { clangd_cmd },
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		json = {
			require("formatter.filetypes.json").prettier,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
		xml = {
			require("formatter.filetypes.xml").xmllint,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "1000" })
	end,
})

augroup("FormatAutogroup", { clear = true })
autocmd("BufWritePost", {
	group = "FormatAutogroup",
	command = "FormatWrite",
})
