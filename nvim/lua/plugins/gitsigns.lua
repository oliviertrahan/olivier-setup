return {
    "lewis6991/gitsigns.nvim",
    dependencies = {"folke/which-key.nvim"},
    lazy = vim.g.started_by_firenvim,
    config = function()
        if vim.g.started_by_firenvim then return end
        require("gitsigns").setup()

        local wk = require("which-key")
        wk.register({
            { "<leader>g", group = "git" }
        })
        vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
        vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
        vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
    end
}
