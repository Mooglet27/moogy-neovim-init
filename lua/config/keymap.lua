-- Return to netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })

-- Move highlighted items, autoindent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted lines up" })

-- Keep Cursor in sight
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines, keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page, center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page, center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, center cursor" })

-- Throw out highlight before pasting
vim.keymap.set("x", "<leader>p", '"_dp', { desc = "Paste without overwriting register" })

-- Yank to system keyboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Delete to the void (instead of the register)
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without saving to register" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete selection without saving to register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item, center cursor" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item, center cursor" })

vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace word under cursor" }
)

-- swap windows quicker
-- vim.keymap.set("n", "<leader>,", "<C-w>w")
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- resize windows
vim.keymap.set("!", "<C-S-Left>", "<C-W>>", { desc = "Increase window width" })
vim.keymap.set("!", "<C-S-Right>", "<C-W><", { desc = "Decrease window width" })
vim.keymap.set("!", "<C-S-Up>", "<C-W>+", { desc = "Increase window height" })
vim.keymap.set("!", "<C-S-Down>", "<C-W>-", { desc = "Decrease window height" })
