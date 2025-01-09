return {
	"akinsho/git-conflict.nvim",
	lazy = vim.g.started_by_firenvim,
	config = function()
		if vim.g.started_by_firenvim then
			return
		end
        require('git-conflict').setup()

		vim.keymap.set("n", "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gcn", "<cmd>GitConflictChooseNone<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gp", "<cmd>GitConflictPrevConflict<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gn", "<cmd>GitConflictNextConflict<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gq", "<cmd>GitConflictListQf<CR>", { noremap = true, silent = true })
	end,
}
