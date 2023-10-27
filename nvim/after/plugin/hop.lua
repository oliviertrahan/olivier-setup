local hop = require("hop")
hop.setup()

vim.keymap.set("n", "s", function() hop.hint_char1() end, { noremap = true })
vim.keymap.set("v", "s", function() hop.hint_char1() end, { noremap = true })

