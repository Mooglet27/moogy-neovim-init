-- nvim-treesitter's main branch only installs parsers and queries; highlighting
-- and indentation are switched on per buffer below. Building parsers needs the
-- tree-sitter CLI (`npm i -g tree-sitter-cli`) and a C compiler.
local ensure_installed = {
    "c",
    "cpp",
    "lua",
    "vim",
    "vimdoc",
    "python",
    "rust",
    "sql",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "java",
    "go",
    "toml",
    "bash",
    "regex",
    "markdown",
    "markdown_inline",
}

-- Filetypes that keep Vim's regex highlighting instead of treesitter
local highlight_disabled = { dockerfile = true }
-- Filetypes where treesitter indentation (still experimental) does worse than the ftplugin
local indent_disabled = { python = true }

local function attach(buf, lang)
    if not highlight_disabled[vim.bo[buf].filetype] then
        pcall(vim.treesitter.start, buf, lang)
    end
    if not indent_disabled[vim.bo[buf].filetype] then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        -- Does not support lazy-loading
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.install(ensure_installed)

            vim.api.nvim_create_autocmd("FileType", {
                desc = "Start treesitter, installing the parser first if it is missing",
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(event.match)
                    if not lang then
                        return
                    end
                    if vim.list_contains(ts.get_installed(), lang) then
                        attach(event.buf, lang)
                    elseif vim.list_contains(ts.get_available(), lang) then
                        ts.install(lang):await(function(err)
                            if not err then
                                vim.schedule(function()
                                    if vim.api.nvim_buf_is_valid(event.buf) then
                                        attach(event.buf, lang)
                                    end
                                end)
                            end
                        end)
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- Must match nvim-treesitter's branch
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true, -- jump forward to the next object if the cursor is not on one
                },
                move = {
                    set_jumps = true, -- add jumps to the jumplist so <C-o> returns
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")

            local function map(modes, lhs, fn, desc)
                vim.keymap.set(modes, lhs, fn, { desc = desc })
            end

            for lhs, spec in pairs({
                af = { "@function.outer", "Around function" },
                ["if"] = { "@function.inner", "Inside function" },
                ac = { "@class.outer", "Around class" },
                ic = { "@class.inner", "Inside class" },
                aa = { "@parameter.outer", "Around argument" },
                ia = { "@parameter.inner", "Inside argument" },
            }) do
                map({ "x", "o" }, lhs, function()
                    select.select_textobject(spec[1], "textobjects")
                end, spec[2])
            end

            -- `]c`/`[c` stay free for diff-mode change navigation, so classes use k
            for lhs, spec in pairs({
                ["]f"] = { move.goto_next_start, "@function.outer", "Next function start" },
                ["]F"] = { move.goto_next_end, "@function.outer", "Next function end" },
                ["[f"] = { move.goto_previous_start, "@function.outer", "Previous function start" },
                ["[F"] = { move.goto_previous_end, "@function.outer", "Previous function end" },
                ["]k"] = { move.goto_next_start, "@class.outer", "Next class start" },
                ["]K"] = { move.goto_next_end, "@class.outer", "Next class end" },
                ["[k"] = { move.goto_previous_start, "@class.outer", "Previous class start" },
                ["[K"] = { move.goto_previous_end, "@class.outer", "Previous class end" },
                ["]a"] = { move.goto_next_start, "@parameter.inner", "Next argument" },
                ["[a"] = { move.goto_previous_start, "@parameter.inner", "Previous argument" },
            }) do
                map({ "n", "x", "o" }, lhs, function()
                    spec[1](spec[2], "textobjects")
                end, spec[3])
            end

            map("n", "<leader>a", function()
                swap.swap_next("@parameter.inner")
            end, "Swap argument with next")
            map("n", "<leader>A", function()
                swap.swap_previous("@parameter.inner")
            end, "Swap argument with previous")
        end,
    },
}
