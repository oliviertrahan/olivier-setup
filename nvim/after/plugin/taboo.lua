vim.api.nvim_create_autocmd('DirChanged', {
    group = vim.api.nvim_create_augroup('Taboo', {}),
    callback = function(ev)
        if (ev.match ~= "tabpage") then
            return
        end
        local curr_dir_name = vim.api.nvim_call_function("fnamemodify", {ev.file, ":t"})
        vim.cmd(string.format('silent! TabooRename %s', curr_dir_name))
    end
})

