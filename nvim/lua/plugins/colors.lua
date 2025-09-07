local validColorSchemes = {
    "kanagawa", "rose-pine-moon", "catppuccin-mocha", "tokyonight-moon",
    "dracula-soft", "sonokai", "oxocarbon", -- "nord",
    "nightfly", -- "gruvbox-baby",
    "everforest"
}

function PickSelectedColor(colorscheme)
    vim.print(string.format("chosen colorscheme: %s", colorscheme))
    vim.cmd(string.format("colorscheme %s", colorscheme))
end

function PickSelectedColorFzf(colorscheme)
    if not colorscheme or #colorscheme == 0 then return end

end

function NewColor()
    local colorscheme = vim.g.colors_name
    local currColorscheme = vim.g.colors_name
    while colorscheme == currColorscheme do
        local choice = math.random(#validColorSchemes)
        colorscheme = validColorSchemes[choice]
    end
    PickSelectedColor(colorscheme)
end

function ListColors()
    local colorStr = ""
    for idx, val in pairs(validColorSchemes) do
        colorStr = colorStr .. val
        if idx ~= #validColorSchemes then colorStr = colorStr .. ", " end
    end
    print(colorStr)
end

function SelectColor()
    vim.ui.select(validColorSchemes, {prompt = "Select ColorScheme: "},
                  function(colorscheme)
        if not colorscheme then return end
        PickSelectedColor(colorscheme)
    end)
end

local function setup_color_schemes()
    require("rose-pine").setup({variant = "moon"})

    require("catppuccin").setup({flavour = "mocha"})

    require("kanagawa").setup({})

    -- Make sure colorscheme inherits the background color and transparency of the terminal
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            local highlights = {
                "NonText", "Normal", "NormalNC", "NormalFloat", "FloatBorder",
                "SignColumn", "Tabline", "TablineFill", "Pmenu", "LineNr",
                "Folded", "SpecialKey", "VertSplit", "EndOfBuffer"
            }
            for _, name in pairs(highlights) do
                vim.cmd.highlight(name .. " guibg=none ctermbg=none")
            end
        end
    })

    NewColor()
    vim.api.nvim_create_user_command("ColorNew", NewColor, {})
    vim.api.nvim_create_user_command("ColorList", ListColors, {})
    vim.api.nvim_create_user_command("ColorSelect", SelectColor, {})
end

return {
    {
        "catppuccin/nvim",
        dependencies = {
            "rose-pine/neovim", "rebelot/kanagawa.nvim",
            "bluz71/vim-nightfly-colors", "luisiacc/gruvbox-baby",
            "folke/tokyonight.nvim", "nyoom-engineering/oxocarbon.nvim",
            "Mofiqul/dracula.nvim", "sainnhe/everforest", "sainnhe/sonokai",
            "loctvl842/monokai-pro.nvim", "nordtheme/vim"
        },
        config = setup_color_schemes
    }
}
