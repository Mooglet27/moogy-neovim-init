local trouble = require('trouble')

trouble.setup {
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    group = true,
    use_diagnostic_signs = true
}

vim.keymap.set("n", "<leader>xn", function()
    trouble.next({skip_groups = true, jump = true})
end,
{silent = true, noremap = true})

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent=true, noremap = true})
