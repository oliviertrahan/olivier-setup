return {
	"gcmt/taboo.vim",
	config = function()
		local tabooGroup = vim.api.nvim_create_augroup("Taboo", {})
		vim.api.nvim_create_autocmd("DirChanged", {
			group = tabooGroup,
			callback = function(ev)
				if ev.match ~= "tabpage" then
					return
				end
				local curr_dir_name = vim.api.nvim_call_function("fnamemodify", { ev.file, ":t" })
				local tab_names = vim.g.tab_names
				vim.cmd(string.format("silent! TabooRename %s", curr_dir_name))
				tab_names[vim.api.nvim_get_current_tabpage()] = curr_dir_name
				vim.g.tab_names = tab_names
			end,
		})
	end,
}
