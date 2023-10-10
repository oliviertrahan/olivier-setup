
-- vim.cmd [[
--     set sessionoptions+=localoptions
--     autocmd BufWinEnter * windo filetype detect
--     autocmd SessionLoadPost * windo filetype detect
--     autocmd VimEnter * so ~/Session.vim
--     autocmd SessionLoadPost * NvimTreeCollapse
--     autocmd VimLeave * mks! ~/Session.vim
-- ]]
