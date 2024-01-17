return {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
        { 'MunifTanjim/nui.nvim' }
    },
    config = function()
        local cmdLine = require("fine-cmdline")
        vim.keymap.set("n", ":", function() cmdLine.open({ default_value = "" }) end, { noremap = true })
        vim.keymap.set("n", "<leader>:", ":", { noremap = true })
    end
}
