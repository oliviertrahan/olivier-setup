vim.keymap.set("n", "<leader>cc", "<cmd>ChatGPT<CR>")
vim.keymap.set("v", "<leader>cc", "y<cmd>ChatGPT<CR>p")
vim.keymap.set({"n", "v"}, "<leader>ce", "<cmd>ChatGPTEditWithInstructions<CR>")
vim.keymap.set({"n", "v"}, "<leader>cr", ":ChatGPTRun ")
vim.keymap.set({"n", "v"}, "<leader>ct", "<cmd>ChatGPTRun translate french<CR>")



