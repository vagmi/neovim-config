vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-fugitive'
    use 'pangloss/vim-javascript'
    use 'Vonr/align.nvim'
    use 'leafgarland/typescript-vim'
    use 'peitalin/vim-jsx-typescript'
    use 'mbbill/undotree'
    use 'rafamadriz/neon' 
    use 'fatih/vim-go'
    use 'nvim-treesitter/nvim-treesitter' 
    use 'tpope/vim-commentary'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'klen/nvim-test'
    use 'nvim-tree/nvim-web-devicons'
    use {
        "mcchrish/zenbones.nvim",
        requires = "rktjmp/lush.nvim"
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use({ "kelly-lin/telescope-ag", requires = { { "nvim-telescope/telescope.nvim" } } })
    use 'tpope/vim-surround'
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup()
        end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            {'arkav/lualine-lsp-progress'}, -- show progress

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'simrat39/inlay-hints.nvim'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        },
    }
    use 'simrat39/symbols-outline.nvim'

    -- Debugging Support
    use('mfussenegger/nvim-dap')
    use {
        'theHamsta/nvim-dap-virtual-text',
        requires = {'mfussenegger/nvim-dap'}
    }
    use {
        "rcarriga/nvim-dap-ui",
        requires = {'mfussenegger/nvim-dap'}
    }

    -- currently used only for macro expansion
    use 'simrat39/rust-tools.nvim' 

    use({
        "glepnir/lspsaga.nvim",
        requires = {'nvim-tree/nvim-web-devicons', opt=true},
        branch = "main",
        config = function()
            require('lspsaga').setup({})
        end,
    })
    use "github/copilot.vim"
end)

