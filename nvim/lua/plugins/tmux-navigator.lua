return {
    'christoomey/vim-tmux-navigator',
    config = function()
        vim.keymap.set({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
        vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
        vim.keymap.set({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
        vim.keymap.set({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
        -- vim.keymap.set({'n', 'v'}, '<C-h>', '<cmd>TmuxNavigatePrevious<cr>')
    end
}
