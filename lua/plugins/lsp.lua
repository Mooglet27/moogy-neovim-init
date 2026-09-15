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
        "saghen/blink.cmp",
        -- Release tags ship a prebuilt Rust fuzzy matcher, so no cargo build
        version = "1.*",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            -- { "luckasRanarison/tailwind-tools.nvim" },
        },
        opts = {
            -- Enter accepts; <C-Space> menu/docs, <C-f>/<C-b> scroll docs,
            -- <Tab>/<S-Tab> snippet jumps, <C-k> signature help, <C-e> close
            keymap = { preset = "enter" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    buffer = { min_keyword_length = 4 },
                },
            },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 250 },
            },
            signature = { enabled = true },
            -- Uses the Rust matcher, warning and falling back to Lua if the binary is missing
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
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
            "saghen/blink.cmp",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            -- Get completion capabilities from blink.cmp
            local capabilities = require("blink.cmp").get_lsp_capabilities()

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
        dependencies = { "saghen/blink.cmp" },
        config = function()
            require("java").setup({
                -- nvim-java downloads its own JDK to run the language server.
                -- Set jdk = { auto_install = false } to use the `java` on
                -- PATH instead; it has to be new enough for the pinned jdtls
                -- (1.54.0 wants JDK 25) or the server refuses to start.
            })

            -- Merged on top of the config nvim-java registered during setup().
            vim.lsp.config("jdtls", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
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
