local lsp = require('lsp-zero')
local util = require('lspconfig/util')
local path = util.path

lsp.preset('minimal')

lsp.ensure_installed({
    'rust_analyzer',
    'pyright',
    'clangd',
})

lsp.skip_server_setup({'rust_analyzer'})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    lsp.default_keymaps({buffer = bufnr})
    vim.keymap.set("n", "<leader>vc", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.rename() end, opts)
end)

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({'*', '.*'}) do
    local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
    if match ~= '' then
      return path.join(path.dirname(match), 'bin', 'python')
    end
  end

  -- Fallback to system Python.
  return exepath('python3') or exepath('python') or 'python'
end

lsp.configure('pyright', {
  before_init = function(_, config)
      local ppath = get_python_path(config.root_dir)
      vim.g.python3_host_prog = ppath
      config.settings.python.pythonPath = ppath
  end
})

lsp.configure('clangd', {
    capabilities = {offsetEncoding = 'utf-8'}
})

lsp.format_on_save({
    format_opts = {
        timeout_ms = 10000,
    },
    -- use null-ls for python
    servers = {
        ['rust_analyzer'] = {'rust'},
        ['null-ls'] = {'python', 'json', 'javascript', 'cpp'},
    }
})

lsp.set_sign_icons({
  error = '✘',
  warn = '',
  hint = '',
  info = '',
})
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()


-- null-ls for formating on save, needed because pyright doesn't support autofmt
local null_ls = require('null-ls')
local clang_config = vim.fn.stdpath('config') .. "/.clang-format"
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.clang_format.with({
            extra_args = {'-style=file:' .. clang_config},
        }),
    }
})


-- let rust_tools handle the rust setup
local rust_lsp = lsp.build_options('rust_analyzer', {
    update_in_insert = true,
    inlay_hints = true,
    -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    hover_actions = {

      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },

      -- Maximal width of the hover window. Nil means no max.
      max_width = nil,

      -- Maximal height of the hover window. Nil means no max.
      max_height = nil,

      -- whether the hover action window gets automatically focused
      -- default: false
      auto_focus = false,
    },
    single_file_support = false,
    on_attach = on_attach_f
})
require('rust-tools').setup({server = rust_lsp})

