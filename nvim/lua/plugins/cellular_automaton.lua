return {
    'eandrju/cellular-automaton.nvim',
    dependencies = {'folke/which-key.nvim'},
    config = function()
        local wk = require("which-key")
        wk.register({ 
            { "<leader>ca", group = "CellularAutomaton" }
        })
        vim.keymap.set("n", "<leader>cag", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Game of Life" })
        vim.keymap.set("n", "<leader>cam", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" })
    end
}
