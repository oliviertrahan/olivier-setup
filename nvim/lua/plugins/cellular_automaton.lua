return {
    'eandrju/cellular-automaton.nvim',
    dependencies = {'folke/which-key.nvim'},
    config = function()
        local wk = require("which-key")
        wk.register({
            ca = {
                name = "CellularAutomaton",
                m = {"<cmd>CellularAutomaton make_it_rain<CR>", "Make it rain"},
                g = {"<cmd>CellularAutomaton game_of_life<CR>", "Game of Life"}
            }
        }, {prefix = "<leader>"})
    end
}
