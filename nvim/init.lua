require("setup.lua_extensions")
require("setup.set")
require("setup.remap")
require("setup.lazy")
require("setup.snippets")
vim.g.tab_names = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

-- Highlight yanked text
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- When we leave terminal mode or when we refocus neovim, then check files for changes
autocmd({ "FocusGained", "TermLeave" }, {
	pattern = "*",
	callback = function()
		vim.cmd("checktime")
	end,
})
