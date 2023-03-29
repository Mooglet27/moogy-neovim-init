-- Bootstrap packer for clones
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd[[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can handle itself
    use 'wbthomason/packer.nvim'

    use 'nvim-tree/nvim-web-devicons'

    -- Telescope for fuzy finding
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use 'nvim-telescope/telescope-file-browser.nvim'

    -- Trouble for showing diagnostics and results
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons'
    }
    use 'folke/lsp-colors.nvim'

    -- Tree-sitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- python indent
    -- treesitter fixed their python indents
    -- use 'Vimjas/vim-python-pep8-indent'

    -- Undo tree
    use 'mbbill/undotree'

    -- Harpoon
    use 'nvim-lua/plenary.nvim'
    use 'theprimeagen/harpoon'

    -- Color Theme
    use 'rebelot/kanagawa.nvim'
    -- Some others I really like
    -- use 'sainnhe/gruvbox-material'
    -- use 'gbprod/nord.nvim'

    -- All import line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- lsp zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            {'simrat39/rust-tools.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use {"akinsho/toggleterm.nvim", tag = '*'}

    -- faster loading
    use 'lewis6991/impatient.nvim'

    -- Auto setup your config after cloning
    if packer_bootstrap then
        require('packer').sync()
    end
end)

