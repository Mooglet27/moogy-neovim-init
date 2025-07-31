return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v4.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "mason-org/mason.nvim",
        lazy = false,
        config = true,
        version = "1.11.0",
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
            { "saadparwaiz1/cmp_luasnip" },
            { "rafamadriz/friendly-snippets" },
            { "onsails/lspkind.nvim" },
            { "luckasRanarison/tailwind-tools.nvim" },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()
            local lspkind = require("lspkind")

            cmp.setup({
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "buffer", keyword_length = 4 },
                    { name = "luasnip" },
                },

                formatting = {
                    format = lspkind.cmp_format({
                        before = require("tailwind-tools.cmp").lspkind_format,
                        mode = "symbol", -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
            })
            cmp.setup.cmdline("/", {
                sources = cmp.config.sources({
                    { name = "nvim_lsp_document_symbol" },
                }, {
                    { name = "buffer" },
                }),
                mapping = cmp.mapping.preset.cmdline(),
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
            { "nvim-java/nvim-java" },
        },
        init = function()
            vim.opt.signcolumn = "yes"
        end,
        config = function()
            local lsp_defaults = require("lspconfig").util.default_config

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities =
                vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- This is where all the LSP shenanigans will live
            local lsp_zero = require("lsp-zero")
            -- lsp_zero.extend_lspconfig()
            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                hint = "󱧡",
                info = "󰙎",
            })

            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
                    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                end,
            })

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })

                vim.keymap.set("n", "<leader>vc", function()
                    vim.lsp.buf.code_action()
                end, { desc = "LSP code action" })

                vim.keymap.set("n", "<leader>vr", function()
                    vim.lsp.buf.rename()
                end, { desc = "LSP variable rename" })
            end)

            lsp_zero.format_on_save({
                servers = {
                    ["ruff"] = { "python" },
                    ["taplo"] = { "toml" },
                    ["gopls"] = { "go", "gomod" },
                },
            })

            require("lspconfig").gopls.setup({
                settings = {
                    gopls = {
                        gofumpt = true,
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "clangd",
                    "ruff",
                    "eslint",
                    "tailwindcss",
                    "ts_ls",
                    "lua_ls",
                    "gopls",
                },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,

                    -- this is the "custom handler" for `lua_ls`
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require("lspconfig").lua_ls.setup(lua_opts)
                    end,
                },
            })
        end,
    },
    {
        "nvim-java/nvim-java",
        lazy = true,
        ft = "java",
        enabled = false,
        init = function()
            -- setup java
            require("java").setup()
            require("lspconfig").jdtls.setup({})
        end,
    },
    {
        url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
        ft = {
            "python",
            "javascript",
            "typescript",
            "html",
            "typescriptreact",
            "javascriptreact",
            "cpp",
            "c",
        },
        dependencies = {
            { "lewis6991/gitsigns.nvim" },
        },
        config = function()
            require("sonarlint").setup({
                server = {
                    cmd = {
                        "sonarlint-language-server",
                        "-stdio",
                        "-analyzers",
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
                    },
                },
                filetypes = {
                    "dockerfile",
                    "python",
                    "c",
                    "cpp",
                    "javascript",
                    "typescript",
                    "typescript",
                    "typescriptreact",
                    "html",
                },
            })
        end,
    },
}
