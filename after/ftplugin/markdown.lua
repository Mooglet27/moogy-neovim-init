-- Core's ftplugin/markdown.lua unconditionally calls vim.treesitter.start(),
-- which crashes (E5108, query_predicates.lua set-lang-from-info-string!) on
-- any fenced code block against nvim-treesitter's frozen master branch.
-- Stop it here; markdown falls back to regex syntax highlighting.
vim.treesitter.stop()
