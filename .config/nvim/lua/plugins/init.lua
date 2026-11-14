-- Requires Neovim 0.11+
require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function() require("plugins.config.colors") end,
  },
  "nvim-lua/plenary.nvim",

  -- LSP: Mason installs servers, mason-lspconfig enables them,
  -- nvim-lspconfig supplies the server definitions for vim.lsp.config
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function() require("plugins.config.lsp") end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
      "rafamadriz/friendly-snippets",
    },
    config = function() require("plugins.config.cmp") end,
  },

  -- Treesitter (main branch; needs the tree-sitter CLI)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function() require("plugins.config.treesitter") end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.config.harpoon") end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
    config = function()
      require("plugins.config.telescope")
      require("plugins.config.zoxide")
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function() require("plugins.config.fugitive") end,
  },
  {
    "mbbill/undotree",
    config = function() require("plugins.config.undotree") end,
  },
  { "andrewferrier/wrapping.nvim", opts = {} },
  {
    "lervag/vimtex",
    lazy = false, -- vimtex must not be lazy-loaded
    init = function() require("plugins.config.tex") end,
  },
  { "vimwiki/vimwiki" },
})
