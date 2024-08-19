return {
	"bkad/CamelCaseMotion",
	opts = {},
	dependencies = {},
	config = function()
		-- vim.keymap.set({ "n", "o", "x" }, "w", "<Plug>CamelCaseMotion_w", { noremap = false })
		-- vim.keymap.set({ "n", "o", "x" }, "b", "<Plug>CamelCaseMotion_b", { noremap = false })
		vim.keymap.set({ "n", "o", "x" }, "e", "<Plug>CamelCaseMotion_e", { noremap = false })
		vim.keymap.set({ "n", "o", "x" }, "ge", "<Plug>CamelCaseMotion_ge", { noremap = false })

		-- vim.keymap.set({ "o", "x" }, "iw", "<Plug>CamelCaseMotion_iw", { noremap = false })
		-- vim.keymap.set({ "o", "x" }, "ib", "<Plug>CamelCaseMotion_ib", { noremap = false })
		vim.keymap.set({ "o", "x" }, "ie", "<Plug>CamelCaseMotion_ie", { noremap = false })
	end,
}
