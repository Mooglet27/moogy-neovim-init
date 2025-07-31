return {
    "mhartington/formatter.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local augroup = vim.api.nvim_create_augroup
        local autocmd = vim.api.nvim_create_autocmd
        augroup("FormatAutogroup", { clear = true })
        autocmd("BufWritePost", {
            group = "FormatAutogroup",
            command = "FormatWrite",
        })
        local types = "formatter.filetypes."
        local util = require("formatter.util")

        local clangd_cmd = function()
            return {
                exe = "clang-format",
                args = {
                    '--style="{BasedOnStyle: Google, IndentWidth: 4}"',
                    "-assume-filename",
                    util.escape_path(util.get_current_buffer_file_name()),
                },
                stdin = true,
                try_node_modules = true,
            }
        end

        require("formatter").setup({
            filetype = {
                python = {
                    --    require(types .. "python").black,
                    function()
                        return {
                            exe = "isort",
                            args = {
                                "-q",
                                "--profile",
                                "black",
                                "--filename",
                                util.escape_path(util.get_current_buffer_file_path()),
                                "-",
                            },
                            stdin = true,
                        }
                    end,
                },
                lua = {
                    function()
                        return {
                            exe = "stylua",
                            args = {
                                "--search-parent-directories",
                                "--indent-width",
                                "4",
                                "--indent-type",
                                "Spaces",
                                "--stdin-filepath",
                                util.escape_path(util.get_current_buffer_file_path()),
                                "--",
                                "-",
                            },
                            stdin = true,
                        }
                    end,
                },
                cpp = { clangd_cmd },
                c = { clangd_cmd },
                javascript = {
                    require(types .. "javascript").prettierd,
                },
                javascriptreact = {
                    require(types .. "javascriptreact").prettierd,
                },
                typescript = {
                    require(types .. "typescript").prettierd,
                },
                typescriptreact = {
                    require(types .. "typescriptreact").prettierd,
                },
                json = {
                    require(types .. "json").prettierd,
                },
                markdown = {
                    require(types .. "markdown").prettierd,
                },
                xml = {
                    require(types .. "xml").xmllint,
                },
                sh = {
                    require(types .. "sh").shfmt,
                },
                html = {
                    require(types .. "html").prettierd,
                },
                yaml = {
                    require(types .. "yaml").prettierd,
                },
                -- java = {
                --    require(types .. "java").clangformat,
                -- },
                java = { clangd_cmd },
                css = { require(types .. "css").prettierd },
            },
        })
    end,
}
