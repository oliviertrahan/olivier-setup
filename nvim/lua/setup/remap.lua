-- the file has extra remaps that are neovim specific
-- common remaps are at common_remaps.vim


local remap_funcs = require("setup.remap_functions")
-- Setup custom commands
vim.api.nvim_create_user_command("SetupReviewBranch", remap_funcs.setup_review_branch, {})

-- remap functions
local open_project_terminal = remap_funcs.open_project_terminal
local open_debug_terminal = remap_funcs.open_debug_terminal
local open_terminal = remap_funcs.open_terminal
local create_debug_buffer = remap_funcs.create_debug_buffer
local cancel_debug_buffer = remap_funcs.cancel_debug_buffer
local run_command_in_debug_terminal = remap_funcs.run_command_in_debug_terminal

vim.keymap.set("n", "<leader>pp", function()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end)

--better yanking experience
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

vim.keymap.set("n", "y", "mpy", { noremap = true }) -- set mark before yanking
vim.keymap.set("n", "Y", "mpv$hy", { noremap = true }) -- set mark before yanking
-- Highlight yanked text
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
		local ev = vim.v.event
		if ev.operator == "y" and not ev.visual then
			vim.cmd("normal! `p") --go back to mark after yanking
		end
	end,
})

vim.keymap.set("n", "<leader>clr", "<cmd>LspRestart<cr>") -- embarassing to have to restart the lsp so often that i want a mapping
vim.keymap.set("n", "<leader>cli", "<cmd>LspInfo<cr>") -- embarassing to have to restart the lsp so often that i want a mapping

vim.keymap.set("n", "<leader>ddo", create_debug_buffer)
vim.keymap.set("n", "<leader>ddc", cancel_debug_buffer)
vim.keymap.set("n", "<leader>dtt", run_command_in_debug_terminal)
vim.keymap.set("n", "<leader>dts", open_debug_terminal)
vim.keymap.set("n", "<leader>qj", "<cmd>cnext<CR>") -- Next entry in quickfix list
vim.keymap.set("n", "<leader>qk", "<cmd>cnext<CR>") -- Previous entry in quickfix list
vim.keymap.set("n", "<leader>qh", "<cmd>colder<CR>") -- Previous quickfix list
vim.keymap.set("n", "<leader>ql", "<cmd>cnewer<CR>") -- Next quickfix list

--Terminal mode improvement
vim.keymap.set("n", "<C-t>", open_project_terminal)
vim.keymap.set("t", "<C-t>", "<C-\\><C-n><C-w>c")
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-p>", "<C-\\><C-o>p")
vim.keymap.set("t", "<C-v>", '<C-\\><C-o>"+P')
vim.keymap.set("t", "<C-o>", "<C-\\><C-o>")

--better terminal management
vim.keymap.set("n", "<leader>t1", function()
	open_terminal(1)
end)
vim.keymap.set("n", "<leader>t2", function()
	open_terminal(2)
end)
vim.keymap.set("n", "<leader>t3", function()
	open_terminal(3)
end)
vim.keymap.set("n", "<leader>t4", function()
	open_terminal(4)
end)
vim.keymap.set("n", "<leader>t5", function()
	open_terminal(5)
end)

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
