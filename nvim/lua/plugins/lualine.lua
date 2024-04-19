return {
    'nvim-lualine/lualine.nvim',
    name = 'lualine',
    dependencies = { { 'nvim-tree/nvim-web-devicons', opt = true } },
    config = function()
        local lualine = require('lualine')
        local function show_macro_recording()
            local recording_register = vim.fn.reg_recording()
            if recording_register == "" then
                return ""
            else
                return "Recording @" .. recording_register
            end
        end
        lualine.setup({
            sections = {
                lualine_b = {
                    {
                        "macro-recording",
                        fmt = show_macro_recording,
                    },
                },
            }
        })
    end
}
