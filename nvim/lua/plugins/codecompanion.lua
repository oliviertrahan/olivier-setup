-- lazy.nvim
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
        "folke/which-key.nvim"
    },
    config = function()
        require("codecompanion").setup({
            opts = {
                log_level = "DEBUG", -- or "TRACE"
                strategies = {chat = {adapter = "openai", model = "gpt-5"}}
            }
        })

        local wk = require("which-key")
        wk.register({
            { "<leader>a", group = "codecompanion" }
        })
        
        vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Companion Actions" })
        vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat<CR>", { desc = "New Chat" })
        vim.keymap.set("n", "<leader>ao", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Open Current Chat" })
        vim.keymap.set({"n", "v"}, "<leader>al", "<cmd>CodeCompanion /lsp<cr>", { desc = "LSP" })
        
        vim.keymap.set("v", "<leader>ao", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to Chat" })
        vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanion /explain<cr>", { desc = "Explain" })
        vim.keymap.set("v", "<leader>af", ":CodeCompanion<CR>", { desc = "Fix Selection" })
    end
}
