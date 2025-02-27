-- https://github.com/LukasPietzschmann/telescope-tabs
-- https://github.com/nvim-telescope/telescope.nvim
-- https://github.com/nvim-telescope/telescope-file-browser.nvim

local function setup_telescope()
	if vim.g.started_by_firenvim then
		return
	end
	---@diagnostic disable: undefined-global
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	local selections_to_skip = 10
	local scroll_many_results_previous = function(prompt_bufnr)
		for _ = 1, selections_to_skip, 1 do
			actions.move_selection_previous(prompt_bufnr)
		end
	end
	local scroll_many_results_next = function(prompt_bufnr)
		for _ = 1, selections_to_skip, 1 do
			actions.move_selection_next(prompt_bufnr)
		end
	end

	telescope.setup({
		defaults = {
			initial_mode = "insert",
			mappings = {
				i = {
					["<C-k>"] = actions.move_selection_previous,
					["<C-j>"] = actions.move_selection_next,
					["<C-c>"] = actions.close,
				},
				n = {
					["<C-k>"] = actions.move_selection_previous,
					["<C-j>"] = actions.move_selection_next,
					["H"] = scroll_many_results_previous,
					["L"] = scroll_many_results_next,
					["<C-c>"] = actions.close,
				},
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},
			buffers = {
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["<C-d>"] = actions.delete_buffer,
					},
				},
			},
		},
	})
	telescope.load_extension("telescope-tabs")
	local tab_display = function(tab_id, _, _, _, is_current)
		local tab_name = vim.g.tab_names[tostring(tab_id)] or ""
		local current_str = is_current and "<" or ""
		local tab_str = string.format("%s: %s %s", tab_id, tab_name, current_str)
		return tostring(tab_str)
	end
	require("telescope-tabs").setup({
		entry_formatter = tab_display,
		entry_ordinal = tab_display,
	})

	local builtin = require("telescope.builtin")
	local find_standard_params = { "rg", "--files", "--hidden", "--smart-case", "-g", "!.git" }
	local find_include_gitignore_params = { "rg", "--files", "--hidden", "-u", "--smart-case", "-g", "!.git" }

	local find_standard = function()
		builtin.find_files({ find_command = find_standard_params })
	end
	local find_standard_on_path = function()
		local path = vim.fn.input("Directory path to search from: ")
		builtin.find_files({ find_command = find_standard_params, cwd = path })
	end
	local find_include_gitignore = function()
		builtin.find_files({ find_command = find_include_gitignore_params })
	end

	vim.keymap.set("n", "<leader>fe", builtin.resume, {})
	vim.keymap.set("n", "<leader>ft", '<cmd>lua require("telescope-tabs").list_tabs()<CR>', {})
	vim.keymap.set("n", "<leader>ff", find_standard, {})
	vim.keymap.set("n", "<leader>fp", find_standard_on_path, {})
	vim.keymap.set("n", "<leader>fhf", find_include_gitignore, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<CR><C-c>", {})
	vim.keymap.set("n", "<leader>fcc", builtin.commands, {})
	vim.keymap.set("n", "<leader>fd", builtin.help_tags, {})
	vim.keymap.set("v", "<leader>fd", 'y<cmd>Telescope help_tags<CR><C-r>"<C-c>', {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("v", "<leader>fg", function()
		vim.cmd("norm! y")
		builtin.grep_string({ search = vim.fn.getreg('"') })
        send_keys("<C-c>")
	end, {})
    
    vim.keymap.set("n", "<leader>fhg", function() builtin.live_grep{
        additional_args = function(_) return {"--hidden"} end
    } end, {})
    
    vim.keymap.set("v", "<leader>fhg", function()
		vim.cmd("norm! y")
        builtin.grep_string{
            search = vim.fn.getreg('"'),
            additional_args = function(_) return {"--hidden"} end
        }
        send_keys("<C-c>")
        end, {}
    )
	vim.keymap.set("n", "<leader>fcg", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {})
	vim.keymap.set("v", "<leader>fcg", 'y<cmd>Telescope current_buffer_fuzzy_find<CR><C-r>"<ESC>', {})
	vim.keymap.set("n", "<leader>flf", function()
        builtin.find_files {
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
    end, {})
	vim.keymap.set("n", "<leader>flg", function()
        builtin.live_grep {
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
    end, {})
	vim.keymap.set("v", "<leader>flg", function()
		vim.cmd("norm! y")
        builtin.grep_string {
            search = vim.fn.getreg('"'),
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
        send_keys("<C-c>")
    end, {})


	local function get_working_directories()
		local tabpages = vim.api.nvim_list_tabpages()
		local working_directories = {}
		for _, tabpage in pairs(tabpages) do
			local tabnum = vim.api.nvim_tabpage_get_number(tabpage)
			local current_directory = vim.api.nvim_call_function("getcwd", { -1, tabnum })
			table.insert(working_directories, current_directory)
		end
		return working_directories
	end

	vim.keymap.set("n", "<leader>fwf", function()
		builtin.find_files({ find_command = find_standard_params, search_dirs = get_working_directories() })
	end, {})
	vim.keymap.set("n", "<leader>fwhf", function()
		builtin.find_files({ find_command = find_include_gitignore_params, search_dirs = get_working_directories() })
	end, {})
	vim.keymap.set("n", "<leader>fhwf", function()
		builtin.find_files({ find_command = find_include_gitignore_params, search_dirs = get_working_directories() })
	end, {})

	vim.keymap.set("n", "<leader>fwg", function()
		builtin.live_grep({ search_dirs = get_working_directories() })
	end, {})

	vim.keymap.set("v", "<leader>fwg", function()
		vim.cmd("norm! y")
		builtin.grep_string({ search_dirs = get_working_directories(), search = vim.fn.getreg('"') })
	end, {})

	vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
end

return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = vim.g.started_by_firenvim,
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{
		"LukasPietzschmann/telescope-tabs",
		lazy = vim.g.started_by_firenvim,
		dependencies = { { "nvim-telescope/telescope.nvim" } },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		lazy = vim.g.started_by_firenvim,
		dependencies = { { "nvim-telescope/telescope.nvim" } },
		config = setup_telescope,
	},
}
