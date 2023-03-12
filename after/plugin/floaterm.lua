vim.keymap.set("n", "<leader>ftg", vim.cmd.FloatermNew)
vim.keymap.set("n", "<leader>tc", function()
    vim.cmd.FloatermNew(vim.fn.input("$> "))
end)

vim.keymap.set(
    "n",
    "<leader>tbr",
    ":FloatermNew --height=0.5 --width=0.4 --wintype=float --position=bottomright"
)
vim.keymap.set(
    "n",
    "<leader>ttr",
    ":FloatermNew --height=0.5 --width=0.4 --wintype=float --position=topright" 
)
