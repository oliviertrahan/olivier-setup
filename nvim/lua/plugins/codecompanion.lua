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
            a = {
                name = "+codecompanion",
                n = {"<cmd>CodeCompanionChat<CR>", "New Chat"},
                o = {"<cmd>CodeCompanionChat Toggle<cr>", "Open Current Chat"},
                a = {"<cmd>CodeCompanionActions<cr>", "Companion Actions"},
                A = {
                    "<cmd>CodeCompanionChat Add<cr>",
                    "Add to Chat",
                    mode = "v"
                },
                e = {"<cmd>CodeCompanion /explain<cr>", "Explain", mode = "v"},
                f = {":CodeCompanion<CR>", "Fix Selection", mode = {"v"}},
                l = {"<cmd>CodeCompanion /lsp<cr>", "LSP", mode = {"n", "v"}}
            }
        }, {prefix = "<leader>"})
    end
}
