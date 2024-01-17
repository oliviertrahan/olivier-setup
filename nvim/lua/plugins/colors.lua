local validColorSchemes = {
    "kanagawa",
    "rose-pine",
    "catppuccin-mocha",
    -- "nightfly",
    -- "gruvbox-baby",
    "tokyonight-moon",
    -- "oxocarbon",
    "dracula"
}

function NewColor()
    local colorscheme = vim.g.colors_name
    local currColorscheme = vim.g.colors_name
    while colorscheme == currColorscheme do
        local choice = math.random(#validColorSchemes)
        colorscheme = validColorSchemes[choice]
    end
    vim.cmd(string.format('colorscheme %s', colorscheme))
    print(string.format("chosen colorscheme: %s", colorscheme))
end

function ListColors()
    local colorStr = ""
    for idx, val in pairs(validColorSchemes) do
        colorStr = colorStr .. val
        if idx ~= #validColorSchemes then
            colorStr = colorStr .. ', '
        end
    end
    print(colorStr)
end

function setup_color_schemes()
    require('rose-pine').setup({
        variant = 'main'
    })

    require('catppuccin').setup({
        flavour = 'mocha'
    })

    require('kanagawa').setup({
    })

    NewColor()
end

return {
    {
        'catppuccin/nvim',
        dependencies = {
            'rose-pine/neovim',
            'rebelot/kanagawa.nvim',
            'bluz71/vim-nightfly-colors',
            'luisiacc/gruvbox-baby',
            'folke/tokyonight.nvim',
            'nyoom-engineering/oxocarbon.nvim',
            'Mofiqul/dracula.nvim',
        },
        config = setup_color_schemes
    }
}
