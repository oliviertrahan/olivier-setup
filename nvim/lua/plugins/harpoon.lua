return {
    'theprimeagen/harpoon',
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>aa", mark.add_file)
        vim.keymap.set("n", "<leader>ah", ui.toggle_quick_menu)
    end
}
