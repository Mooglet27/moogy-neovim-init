local lsp = require('lsp-zero')
local util = require('lspconfig/util')
local path = util.path

lsp.preset('recommended')

lsp.ensure_installed({
    'rust_analyzer',
    'pyright',
})

lsp.skip_server_setup({'rust_analyzer'})

local on_attach_f = function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "<leader>vc", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.rename() end, opts)
end

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
    config.settings.python.pythonPath = get_python_path(config.root_dir)
  end
})


lsp.on_attach(on_attach_f)
lsp.setup_nvim_cmp({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
})

lsp.format_on_save({
    servers = {
        ['rust_analyzer'] = {'rust'},
    }
})
lsp.nvim_workspace()
lsp.setup()

local rust_lsp = lsp.build_options('rust_analyzer', {
    single_file_support = false,
    on_attach = on_attach_f
})
require('rust-tools').setup({server = rust_lsp})

