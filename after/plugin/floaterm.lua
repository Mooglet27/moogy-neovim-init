vim.keymap.set("n", "<leader>ftg", vim.cmd.FloatermNew)
vim.keymap.set("n", "<leader>ft", function()
    vim.cmd.FloatermNew(vim.fn.input("$> "))
end)
