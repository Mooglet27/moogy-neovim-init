-- Live-preview LSP rename; the <F2> and <leader>vr keymaps live in lsp.lua's LspAttach
return {
    "smjonas/inc-rename.nvim",
    -- Loaded on LspAttach rather than on the command, so the preview works on first use
    event = "LspAttach",
    cmd = "IncRename",
    opts = {},
}
