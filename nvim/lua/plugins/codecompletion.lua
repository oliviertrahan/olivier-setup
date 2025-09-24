-- lazy.nvim
return {
    "olimorris/codecompanion.nvim",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
    config = function()
        require("codecompanion").setup {
            strategies = {chat = {adapter = "openai", model = "gpt-5"}},
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "DEBUG" -- or "TRACE"
            }
        }

        vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat<CR>",
                       {noremap = true, silent = true})
        vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>",
                       {noremap = true, silent = true})
        vim.keymap.set("v", "<leader>aa", "<cmd>CodeCompanionChat Add<cr>",
                       {noremap = true, silent = true})
        vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanion /explain<cr>",
                       {noremap = true, silent = true})
        vim.keymap.set('v', '<leader>af', ':CodeCompanion<CR>',
                       {noremap = true, silent = true})
    end
}
