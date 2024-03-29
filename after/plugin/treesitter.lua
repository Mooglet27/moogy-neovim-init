require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "cpp", "lua", "vim", "query", "python", "rust", "sql", "html", "javascript" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parseres when entering buffer
	auto_install = true,

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},
	indent = {
		enabled = true,
		--         disable = { "python" },
	},
})
