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
                local curr_tabpage = get_active_tabpage_for_buffer(ev.buf)
				local curr_dir_name = vim.api.nvim_call_function("fnamemodify", { ev.file, ":t" })
                if curr_tabpage == nil then
                    print(string.format("No tabpage found for buffer %d. Unexpected error.", ev.buf))
                    return
                end
				local tab_names = vim.g.tab_names
				vim.cmd(string.format("silent! TabooRename %s", curr_dir_name))
				tab_names[tostring(curr_tabpage)] = curr_dir_name
				vim.g.tab_names = tab_names
			end,
		})
	end,
}
