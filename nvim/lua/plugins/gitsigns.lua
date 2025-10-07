return {
    "lewis6991/gitsigns.nvim",
    dependencies = {"folke/which-key.nvim"},
    lazy = vim.g.started_by_firenvim,
    config = function()
        if vim.g.started_by_firenvim then return end
        require("gitsigns").setup()

        local wk = require("which-key")

        wk.register({
            ["<leader>g"] = {
                name = "+git",
                p = {"<cmd>Gitsigns preview_hunk<CR>", "Preview hunk"},
                h = {"<cmd>Gitsigns prev_hunk<CR>", "Previous hunk"},
                l = {"<cmd>Gitsigns next_hunk<CR>", "Next hunk"},
                t = {"<cmd>Gitsigns blame_line<CR>", "Blame line"}
                -- Uncomment below to use toggle_current_line_blame instead
                -- t = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle line blame" },
            }
        })
    end
}
