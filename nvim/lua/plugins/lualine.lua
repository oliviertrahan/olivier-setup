return {
    'nvim-lualine/lualine.nvim',
    name = 'lualine',
    dependencies = { { 'nvim-tree/nvim-web-devicons', opt = true }, 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
        require('lualine').setup()
        require('ts_context_commentstring').setup {
            enable_autocmd = false
        }
    end
}
