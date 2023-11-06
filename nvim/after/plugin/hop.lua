local hop = require("hop")
hop.setup()

vim.keymap.set({"n", "v"}, "s", function() hop.hint_char1() end, { noremap = true })
vim.keymap.set({"n", "v"}, "<leader>j", function() hop.hint_lines_skip_whitespace() end, { noremap = true })
vim.keymap.set({"n", "v"}, "<leader>k", function() hop.hint_lines_skip_whitespace() end, { noremap = true })
