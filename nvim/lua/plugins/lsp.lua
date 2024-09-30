local function setup_lsp()
	local lsp = require("lsp-zero")

	lsp.preset("recommended")

	lsp.ensure_installed({
		-- 'rust_analyzer',
		"csharp_ls",
		"volar",
		"pyright",
		"tsserver",
		"yamlls",
		"eslint",
		"bashls",
		"lua_ls",
		"tailwindcss",
	})

	-- Fix Undefined global 'vim'
	lsp.nvim_workspace()

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "sh,zsh",
		callback = function()
			vim.lsp.start({
				name = "bash-language-server",
				cmd = { "bash-language-server", "start" },
			})
		end,
	})

    --TODO: cmp section coupled to LSP, figure out how to separate out the cmp
	local cmp = require("cmp")
	local cmp_select = { behavior = cmp.SelectBehavior.Select }
	local cmp_mappings = lsp.defaults.cmp_mappings({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	})

	cmp_mappings["<Tab>"] = nil
	cmp_mappings["<S-Tab>"] = nil

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
    
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
      {
        { name = 'path' }
      },
      {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })
    
	lsp.setup_nvim_cmp({
		mapping = cmp_mappings,
	})

    -- end cmp section

	lsp.set_preferences({
		suggest_lsp_servers = false,
		sign_icons = {
			error = "E",
			warn = "W",
			hint = "H",
			info = "I",
		},
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local definitions = vim.lsp.buf.definition
			local declarations = vim.lsp.buf.declaration
			local references = vim.lsp.buf.references
			local implementations = vim.lsp.buf.implementation
			local workspace_symbols = vim.lsp.buf.workspace_symbol
			local document_symbols = vim.lsp.buf.document_symbol

			local telescope = require("telescope.builtin")
			if telescope then
				definitions = telescope.lsp_definitions
				references = '<cmd>lua require("telescope.builtin").lsp_references()<CR><ESC>'
				implementations = telescope.lsp_implementations
				workspace_symbols = telescope.lsp_workspace_symbols
				document_symbols = telescope.lsp_document_symbols
			end

			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gd", definitions)
			vim.keymap.set("n", "gD", declarations)
			vim.keymap.set("n", "gr", references)
			vim.keymap.set("n", "gi", implementations)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "=", vim.lsp.buf.format, opts)
			vim.keymap.set("n", "<leader>vws", workspace_symbols, opts)
			vim.keymap.set("n", "<leader>vds", document_symbols, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("v", "<leader>vca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
			vim.keymap.set("v", "<leader>vrn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>vh", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>vh", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, opts)

			-- if vim.lsp.buf.format then
			--     vim.api.nvim_create_autocmd("BufWritePre", {
			--         buffer = ev.buf,
			--         callback = function()
			--             vim.lsp.buf.format()
			--         end
			--     })
			-- end
		end,
	})

	lsp.setup()

	local lsp_config = require("lspconfig")

	if lsp_config.csharp_ls then
		lsp_config.csharp_ls.setup({
			root_dir = function(startpath)
				local cwd = vim.fn.getcwd()
				return lsp_config.util.root_pattern("*.sln")(cwd)
					or lsp_config.util.root_pattern("*.sln")(startpath)
					or lsp_config.util.root_pattern("*.csproj")(cwd)
					or lsp_config.util.root_pattern("*.csproj")(startpath)
					or lsp_config.util.root_pattern("*.fsproj")(cwd)
					or lsp_config.util.root_pattern("*.fsproj")(startpath)
					or lsp_config.util.root_pattern(".git")(startpath)
			end,
		})
	end

	if lsp_config.tsserver and lsp_config.tsserver.setup then
		lsp_config.tsserver.setup({
			filetypes = { "typescript", "javascript" },
		})
	end

	if lsp_config.volar and lsp_config.volar.setup then
		lsp_config.volar.setup({
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
		})
	end
    
	if lsp_config.pyright and lsp_config.pyright.setup then
		lsp_config.pyright.setup({})
	end


	vim.diagnostic.config({
		virtual_text = true,
	})

	require("lsp-file-operations").setup()
end

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },

			-- nvim-lsp-file-operations
			{ "antosha417/nvim-lsp-file-operations" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-tree/nvim-tree.lua" },
		},
		config = setup_lsp,
	},
}
