return {
	"akinsho/git-conflict.nvim",
	lazy = vim.g.started_by_firenvim,
	config = function()
		if vim.g.started_by_firenvim then
			return
		end
		require("gitsigns").setup()

		vim.keymap.set("n", "<leader>co", "<cmd>GitConflictChooseOurs<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gp", "<cmd>GitConflictPrevConflict<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gn", "<cmd>GitConflictNextConflict<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gq", "<cmd>GitConflictListQf<CR>", { noremap = true, silent = true })
	end,
}
