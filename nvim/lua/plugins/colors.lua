local validColorSchemes = {
    "kanagawa",
    "rose-pine-moon",
    "catppuccin-mocha",
    "tokyonight-moon",
    "dracula-soft",
    "sonokai",
    "nord"
    -- "oxocarbon",
    -- "nightfly",
    -- "gruvbox-baby",
    -- "everforest",
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

local function setup_color_schemes()
    require('rose-pine').setup({
        variant = 'moon'
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
            'sainnhe/everforest',
            'sainnhe/sonokai',
            'loctvl842/monokai-pro.nvim',
            'nordtheme/vim'
        },
        config = setup_color_schemes
    }
}
