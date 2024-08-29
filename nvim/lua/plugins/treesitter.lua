-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/playground",
		"andymass/vim-matchup",
	},
	build = function()
		local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
		ts_update()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			matchup = {
				enable = true,
			},
			textobjects = {
				swap = {
					enable = true,
					swap_next = {
						["<leader>l"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>h"] = "@parameter.inner",
					},
				},
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["a="] = { query = "@assignment.rhs", desc = "Select right hand assignment expression" },
						["i="] = { query = "@assignment.lhs", desc = "Select left hand assignment expression" },

						["af"] = { query = "@function.outer", desc = "Select outer part of the function" },
						["if"] = { query = "@function.inner", desc = "Select inner part of the function" },

						["ac"] = { query = "@class.outer", desc = "Select the outer part of the class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

						["ai"] = { query = "@conditional.outer", desc = "Select outer part of the conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select the inner part of the conditional" },

						["as"] = { query = "@scope", desc = "Select language scope" },
						["is"] = { query = "@scope", desc = "Select language scope" },
					},
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true or false
					include_surrounding_whitespace = false,
				},
			},
		})
	end,
}
