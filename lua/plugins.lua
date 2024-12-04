vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-fugitive'
    use 'pangloss/vim-javascript'
    use { 'echasnovski/mini.align', branch = 'stable' }
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
    use 'rafcamlet/nvim-luapad'
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
    use { "meatballs/notebook.nvim", 
          config = function() 
              require("notebook").setup() 
          end
        }
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
    use({
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    })

    -- Debugging Support
    use('mfussenegger/nvim-dap')
    use {
        'theHamsta/nvim-dap-virtual-text',
        requires = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'}
    }
    use {
        "rcarriga/nvim-dap-ui",
        requires = {'mfussenegger/nvim-dap'}
    }

    use({
        "nvimdev/lspsaga.nvim",
        requires = {'nvim-tree/nvim-web-devicons', opt=true},
        branch = "main",
        config = function()
            require('lspsaga').setup({})
        end,
    })
    -- use "github/copilot.vim"
    use "MunifTanjim/nui.nvim"
    use ({
        "vagmi/neoai.nvim",
        -- "~/work/opensource/neoai.nvim",
        require = { "MunifTanjim/nui.nvim" },
        opt = false
    })
    use "zbirenbaum/copilot.lua"
    use {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function ()
        require("copilot_cmp").setup()
      end
    }
    use {'stevearc/dressing.nvim'}

    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })

    use {
        'yetone/avante.nvim',
        run = "BUILD_FROM_SOURCE=true make", -- latest greatest bleeding edge
        requires = {
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons', -- or 'echasnovski/mini.icons'
            'zbirenbaum/copilot.lua',
            {
                'HakonHarnes/img-clip.nvim',
                config = function()
                    require('img-clip').setup({
                        default = {
                            embed_image_as_base64 = false,
                            prompt_for_file_name = false,
                            drag_and_drop = {
                                insert_mode = true,
                            },
                            use_absolute_path = true,
                        },
                    })
                end,
            },
            {
                'MeanderingProgrammer/render-markdown.nvim',
                config = function()
                    require('render-markdown').setup({
                        file_types = { "markdown", "Avante" },
                    })
                end,
                ft = { "markdown", "Avante" },
            },
        },
        config = function()
            require('avante_lib').load()
            require('avante').setup()
        end,
    }
end)

