return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        config = true,
        -- version = "1.11.0",
        enabled = true,
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
            -- { "luckasRanarison/tailwind-tools.nvim" },
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            cmp.setup({
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "buffer", keyword_length = 4 },
                    { name = "luasnip" },
                },

                formatting = {
                    format = lspkind.cmp_format({
                        -- before = require("tailwind-tools.cmp").lspkind_format,
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
                    ["<C-f>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-b>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
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

    -- LSP using builtin vim.lsp.config API
    {
        "mason-org/mason-lspconfig.nvim",
        version = "1.32.0",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
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
                    "taplo",
                    "matlab_ls",
                    "dockerls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            -- Get capabilities from nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Resolve the MATLAB installation root (dir containing bin/matlab).
            -- Falls back to the first `matlab` found on PATH when no explicit
            -- path is given.
            local function matlab_install_path(explicit)
                if explicit and explicit ~= "" then
                    return explicit
                end
                local exe = vim.fn.exepath("matlab")
                if exe == "" then
                    return ""
                end
                -- Follow symlinks, then strip the trailing /bin/matlab
                return vim.fn.fnamemodify(vim.fn.resolve(exe), ":h:h")
            end

            -- Configure LSP servers using builtin vim.lsp.config
            vim.lsp.config("pyright", {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    "pyrightconfig.json",
                    ".git",
                },
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
                capabilities = capabilities,
            })

            vim.lsp.config("ruff", {
                cmd = { "ruff", "server", "--preview" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
                capabilities = capabilities,
            })

            vim.lsp.config("clangd", {
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_markers = {
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "configure.ac",
                    ".git",
                },
                capabilities = capabilities,
            })

            vim.lsp.config("eslint", {
                cmd = { "vscode-eslint-language-server", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                    "vue",
                    "svelte",
                    "astro",
                },
                root_markers = {
                    ".eslintrc",
                    ".eslintrc.js",
                    ".eslintrc.cjs",
                    ".eslintrc.yaml",
                    ".eslintrc.yml",
                    ".eslintrc.json",
                    "eslint.config.js",
                    "package.json",
                    ".git",
                },
                capabilities = capabilities,
            })

            vim.lsp.config("tailwindcss", {
                cmd = { "tailwindcss-language-server", "--stdio" },
                filetypes = {
                    "aspnetcorerazor",
                    "astro",
                    "astro-markdown",
                    "blade",
                    "clojure",
                    "django-html",
                    "htmldjango",
                    "edge",
                    "eelixir",
                    "elixir",
                    "ejs",
                    "erb",
                    "eruby",
                    "gohtml",
                    "gohtmltmpl",
                    "haml",
                    "handlebars",
                    "hbs",
                    "html",
                    "html-eex",
                    "heex",
                    "jade",
                    "leaf",
                    "liquid",
                    "markdown",
                    "mdx",
                    "mustache",
                    "njk",
                    "nunjucks",
                    "php",
                    "razor",
                    "slim",
                    "twig",
                    "css",
                    "less",
                    "postcss",
                    "sass",
                    "scss",
                    "stylus",
                    "sugarss",
                    "javascript",
                    "javascriptreact",
                    "reason",
                    "rescript",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "svelte",
                },
                root_markers = {
                    "tailwind.config.js",
                    "tailwind.config.cjs",
                    "tailwind.config.mjs",
                    "tailwind.config.ts",
                    "postcss.config.js",
                    "postcss.config.cjs",
                    "postcss.config.mjs",
                    "postcss.config.ts",
                    "package.json",
                    "node_modules",
                    ".git",
                },
                capabilities = capabilities,
            })

            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
                root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = {
                    ".luarc.json",
                    ".luarc.jsonc",
                    ".luacheckrc",
                    ".stylua.toml",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                    ".git",
                },
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
                capabilities = capabilities,
            })

            vim.lsp.config("gopls", {
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_markers = { "go.work", "go.mod", ".git" },
                settings = {
                    gopls = {
                        gofumpt = true,
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        usePlaceholders = true,
                    },
                },
                capabilities = capabilities,
            })

            vim.lsp.config("taplo", {
                cmd = { "taplo", "lsp", "stdio" },
                filetypes = { "toml" },
                root_markers = { "*.toml", ".git" },
                capabilities = capabilities,
            })

            vim.lsp.config("matlab_ls", {
                cmd = { "matlab-language-server", "--stdio" },
                filetypes = { "matlab" },
                root_markers = { ".git" },
                settings = {
                    MATLAB = {
                        indexWorkspace = false,
                        -- MATLAB installation root (dir containing bin/matlab).
                        -- Pass an explicit path to override, e.g.
                        -- matlab_install_path("/opt/matlab/r2024b")
                        installPath = matlab_install_path(),
                        matlabConnectionTiming = "onStart",
                        telemetry = true,
                    },
                },
                capabilities = capabilities,
            })

            vim.lsp.config("dockerls", {
                cmd = {
                    vim.fn.stdpath("data") .. "/mason/bin/docker-langserver",
                    "--stdio",
                },
                filetypes = { "dockerfile" },
                root_markers = { "Dockerfile", ".git" },
                capabilities = capabilities,
            })

            -- Enable all configured servers
            vim.lsp.enable("pyright")
            vim.lsp.enable("ruff")
            vim.lsp.enable("clangd")
            vim.lsp.enable("eslint")
            vim.lsp.enable("tailwindcss")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("taplo")
            vim.lsp.enable("matlab_ls")
            vim.lsp.enable("dockerls")

            -- LSP keymaps and autocommands
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set(
                        "n",
                        "K",
                        vim.lsp.buf.hover,
                        vim.tbl_extend("force", opts, { desc = "Show hover information" })
                    )
                    vim.keymap.set(
                        "n",
                        "gd",
                        vim.lsp.buf.definition,
                        vim.tbl_extend("force", opts, { desc = "Go to definition" })
                    )
                    vim.keymap.set(
                        "n",
                        "gD",
                        vim.lsp.buf.declaration,
                        vim.tbl_extend("force", opts, { desc = "Go to declaration" })
                    )
                    vim.keymap.set(
                        "n",
                        "gi",
                        vim.lsp.buf.implementation,
                        vim.tbl_extend("force", opts, { desc = "Go to implementation" })
                    )
                    vim.keymap.set(
                        "n",
                        "go",
                        vim.lsp.buf.type_definition,
                        vim.tbl_extend("force", opts, { desc = "Go to type definition" })
                    )
                    vim.keymap.set(
                        "n",
                        "gr",
                        vim.lsp.buf.references,
                        vim.tbl_extend("force", opts, { desc = "Show references" })
                    )
                    vim.keymap.set(
                        "n",
                        "gs",
                        vim.lsp.buf.signature_help,
                        vim.tbl_extend("force", opts, { desc = "Show signature help" })
                    )
                    vim.keymap.set(
                        "n",
                        "<F2>",
                        vim.lsp.buf.rename,
                        vim.tbl_extend("force", opts, { desc = "Rename symbol" })
                    )
                    vim.keymap.set({ "n", "x" }, "<F3>", function()
                        vim.lsp.buf.format({ async = true })
                    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
                    vim.keymap.set(
                        "n",
                        "<F4>",
                        vim.lsp.buf.code_action,
                        vim.tbl_extend("force", opts, { desc = "Code actions" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>vc",
                        vim.lsp.buf.code_action,
                        { desc = "LSP code action", buffer = event.buf }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>vr",
                        vim.lsp.buf.rename,
                        { desc = "LSP variable rename", buffer = event.buf }
                    )

                    -- Navigate diagnostics
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.goto_prev({ float = false })
                    end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.goto_next({ float = false })
                    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                end,
            })

            -- Format on save for specific filetypes
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.toml", "*.go", "*.mod" },
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    },
    -- Java. jdtls and its bundles (lombok, java-test, java-debug,
    -- spring-boot-tools) are downloaded and wired up by nvim-java itself,
    -- which is why jdtls is not in mason-lspconfig's ensure_installed above:
    -- a second, mason managed jdtls would fight with this one.
    {
        "nvim-java/nvim-java",
        lazy = false,
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("java").setup({
                -- nvim-java downloads its own JDK to run the language server.
                -- Set jdk = { auto_install = false } to use the `java` on
                -- PATH instead; it has to be new enough for the pinned jdtls
                -- (1.54.0 wants JDK 25) or the server refuses to start.
            })

            -- Merged on top of the config nvim-java registered during setup().
            vim.lsp.config("jdtls", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        -- Readable sources when jumping into a dependency
                        -- that ships without a sources jar.
                        contentProvider = { preferred = "fernflower" },
                        configuration = { updateBuildConfiguration = "interactive" },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        format = { insertSpaces = true, tabSize = 4 },
                    },
                },
            })

            vim.lsp.enable("jdtls")
        end,
    },
    {
        url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
        enabled = true,
        ft = {
            "python",
            -- "javascript",
            -- "typescript",
            "html",
            -- "typescriptreact",
            -- "javascriptreact",
            "cpp",
            "c",
            "java",
        },
        dependencies = {
            { "lewis6991/gitsigns.nvim" },
        },
        config = function()
            -- Pass only the analyzers that are actually on disk. Mason does
            -- not ship every jar listed here (sonarcfamily, for one, arrives
            -- as a bare .asc signature), and an -analyzers path that does not
            -- exist is still handed to the server verbatim.
            local mason = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
            local analyzer_dir = mason .. "/share/sonarlint-analyzers/"
            local cmd = { "sonarlint-language-server", "-stdio", "-analyzers" }

            for _, jar in ipairs({
                "sonarpython.jar",
                "sonarjs.jar",
                "sonarcfamily.jar",
                "sonarhtml.jar",
                "sonarjava.jar",
                -- Second java analyzer: the symbolic execution rules
                -- (null dereference, resource leaks, dead code paths).
                "sonarjavasymbolicexecution.jar",
            }) do
                local jar_path = analyzer_dir .. jar
                if vim.fn.filereadable(jar_path) == 1 then
                    table.insert(cmd, jar_path)
                end
            end

            require("sonarlint").setup({
                server = {
                    cmd = cmd,
                },
                filetypes = {
                    "dockerfile",
                    "python",
                    "c",
                    "cpp",
                    -- "javascript",
                    -- "typescript",
                    -- "typescript",
                    -- "typescriptreact",
                    "html",
                    "java",
                },
            })
        end,
    },
}
