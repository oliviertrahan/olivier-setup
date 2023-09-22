vim.g.neoformat_try_node_exe = 1
vim.api.nvim_create_autocmd(
    'BufWritePre,InsertLeavePre',
    {
        pattern='*.js, *.vue',
        command='Neoformat'
    }
)
