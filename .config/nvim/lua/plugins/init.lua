require('lazy').setup({
	{
	  "folke/tokyonight.nvim",
	  config = function()
			require('plugins.config.colors')
		end
	},
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
  
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
  
            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        },
        config = function()
            require('plugins.config.lsp')
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
			require('plugins.config.treesitter')
		end
    },
    {
        'ThePrimeagen/harpoon',
        config = function()
            require('plugins.config.harpoon')
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('plugins.config.telescope')
        end
    },
    {
        'jvgrootveld/telescope-zoxide',
        config = function()
            require('plugins.config.zoxide') 
        end
    },
    {
        'tpope/vim-fugitive',
        config = function()
            require('plugins.config.fugitive') 
        end
    },
    {
        'mbbill/undotree',
        config = function()
            require('plugins.config.undotree') 
        end
    },
	'nvim-treesitter/playground',
	'CamdenClark/flyboy',
	'vimwiki/vimwiki'
})
