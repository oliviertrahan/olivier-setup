local cmdLine = require("fine-cmdline")
vim.keymap.set("n", ":", function() cmdLine.open({ default_value = ""}) end, { noremap = true })
