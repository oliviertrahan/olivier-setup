vim.cmd("source ~/.config/nvim/common_remaps.vim")
vim.g.tab_names = {}

require("setup.lazy")
require("setup.lua_extensions")
require("setup.set")
require("setup.remap")
require("setup.snippets")
require("setup.print_snippets")
require("setup.buf_write_pre")
require("setup.buf_read_pre")
local autocmd = vim.api.nvim_create_autocmd

function R(name)
	require("plenary.reload").reload_module(name)
end

-- When we leave terminal mode or when we refocus neovim, then check files for changes
autocmd({ "FocusGained", "TermLeave" }, {
	pattern = "*",
	callback = function()
		vim.cmd("checktime")
	end,
})
