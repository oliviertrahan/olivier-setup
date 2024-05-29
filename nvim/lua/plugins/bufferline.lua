return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "tabs",
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
			},
		})
	end,
}
