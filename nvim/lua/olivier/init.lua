require("olivier.set")
require("olivier.remap")
require("olivier.packer")
require("olivier.nvim-web-devicons")
require("olivier.snippets")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


autocmd('FocusGained,TermLeave', {
    pattern = '*',
    callback = function()
        vim.cmd('checktime')
    end,
})
