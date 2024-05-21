return {
	"lewis6991/gitsigns.nvim",
	lazy = vim.g.started_by_firenvim,
	config = function()
		if vim.g.started_by_firenvim then
			return
		end
		require("gitsigns").setup()

		vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns next_hunk<CR>", { noremap = true, silent = true })
		-- vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns blame_line<CR>", { noremap = true, silent = true })
	end,
}
