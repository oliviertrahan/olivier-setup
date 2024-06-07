-- the file has extra remaps that are neovim specific
-- common remaps are at common_remaps.vim
local remap_funcs = require("setup.remap_functions")
local open_project_terminal = remap_funcs.open_project_terminal
local open_terminal = remap_funcs.open_terminal
local create_debug_buffer = remap_funcs.create_debug_buffer
vim.g.mapleader = " "

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
vim.keymap.set("n", "Y", "mpY", { noremap = true }) -- set mark before yanking
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

vim.keymap.set("n", "<leader>ss", 'yiw:%s/<C-r>"//g<Left><Left>') -- go back to last file
vim.keymap.set("v", "<leader>ss", 'y:%s/<C-r>"//g<Left><Left>') -- go back to last file
vim.keymap.set("n", "<leader>dd", create_debug_buffer)
vim.keymap.set("n", "<leader>qh", "<cmd>colder<CR>") -- Previous quickfix list
vim.keymap.set("n", "<leader>ql", "<cmd>cnewer<CR>") -- Next quickfix list

-- better window management
vim.keymap.set("n", "<leader>wo", "<cmd>vsplit<CR><C-w>l")
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR><C-w>j")
vim.keymap.set("n", "<leader>wc", "<C-w>c")
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")

--better tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabonly<CR>")
vim.keymap.set("n", "<leader>tl", "<cmd>+tabnext<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>-tabnext<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>+tabnext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>-tabnext<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>+tabmove<CR>")
vim.keymap.set("n", "<leader>tN", "<cmd>-tabmove<CR>")

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
