local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'rust_analyzer',
    'pyright',
})

lsp.skip_server_setup({'rust_analyzer'})

local on_attach_f = function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
end

lsp.on_attach(on_attach_f)
lsp.setup()

local rust_lsp = lsp.build_options('rust_analyzer', {
    single_file_support = false,
    on_attach = on_attach_f
})
require('rust-tools').setup({server = rust_lsp})

