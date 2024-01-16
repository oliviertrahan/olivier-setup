-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use({
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })

    use({
        'nvim-telescope/telescope-file-browser.nvim',
        requires = { { 'nvim-telescope/telescope.nvim' } }
    })

    use({
        'nvim-tree/nvim-tree.lua',
        as = 'nvim-tree'
    })

    use({
        'nvim-tree/nvim-web-devicons',
        as = 'nvim-devicons'
    })

    use({
        'sbdchd/neoformat',
        as = 'neoformat'
    })

    use({
        'folke/trouble.nvim',
        as = 'trouble',
        requires = { { 'nvim-tree/nvim-web-devicons' } }
    })

    use {
        'nvim-lualine/lualine.nvim',
        as = 'lualine',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    })

    use({
        'VonHeikemen/fine-cmdline.nvim',
        requires = {
            { 'MunifTanjim/nui.nvim' }
        }
    })

    -- debugging

    use({
        'mfussenegger/nvim-dap',
        as = 'nvim-dap'
    })


    use({
        'rcarriga/nvim-dap-ui',
        as = 'nvim-dap-ui',
        requires = { 'mfussenegger/nvim-dap' }
    })

    --colorschemes
    use({
        'rose-pine/neovim',
        as = 'rose-pine'
    })

    use({
        'catppuccin/nvim',
        as = 'catppuccin'
    })

    use({
        'rebelot/kanagawa.nvim',
        as = 'kanagawa'
    })

    use({
        'bluz71/vim-nightfly-colors',
        as = 'nightfly-colors'
    })

    use({
        'luisiacc/gruvbox-baby',
        as = 'gruvbox-baby'
    })

    use({
        'folke/tokyonight.nvim',
        as = 'tokyonight'
    })

    use({
        'nyoom-engineering/oxocarbon.nvim',
        as = 'oxocarbon'
    })

    use({
        'Mofiqul/dracula.nvim',
    })
    use('vim-scripts/vis')
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('tpope/vim-surround')
    use('tpope/vim-commentary')
    use('mg979/vim-visual-multi')
    use('JoosepAlviste/nvim-ts-context-commentstring', {
        config = function()
            require('ts_context_commentstring').setup {
                enable_autocmd = false
            }
        end
    })
    use('gcmt/taboo.vim')
    use('phaazon/hop.nvim')
    use('nvim-treesitter/nvim-treesitter-context');
    use('christoomey/vim-tmux-navigator');
    use('github/copilot.vim')
    use({
      "jackMort/ChatGPT.nvim",
        config = function()
          require("chatgpt").setup()
        end,
        requires = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim"
        }
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)
