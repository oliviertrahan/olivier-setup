return {
    'gcmt/taboo.vim',
    config = function()
        local tabooGroup = vim.api.nvim_create_augroup('Taboo', {})
        vim.api.nvim_create_autocmd('DirChanged', {
            group = tabooGroup,
            callback = function(ev)
                if (ev.match ~= "tabpage") then
                    return
                end
                local curr_dir_name = vim.api.nvim_call_function("fnamemodify", { ev.file, ":t" })
                vim.cmd(string.format('silent! TabooRename %s', curr_dir_name))
            end
        })
    end
}
