local function setup_all_lsps()

    local mason = require('mason')
    local mason_lsp_config = require('mason-lspconfig')
    mason.setup()
    mason_lsp_config.setup {automatic_installation = true}

    local lsp_config = require("lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require(
                                           'cmp_nvim_lsp').default_capabilities())

    local function setup_pyright()
        local root_dir = vim.fn.getcwd()
        local function get_python_path()

            -- Check common venv locations
            local venv_paths = {".venv", "venv", "env"}
            for _, venv in ipairs(venv_paths) do
                local py_path = vim.fn.expand(
                                    string.format("%s/%s/bin/python", root_dir,
                                                  venv))
                if vim.fn.filereadable(py_path) == 1 then
                    return py_path
                end
            end

            local pythonPath = vim.fn.exepath("python")
            if not pythonPath then
                pythonPath = vim.fn.exepath("python3")
            end
            return pythonPath
        end

        -- Reconfigure Pyright dynamically per buffer
        vim.lsp.start({
            name = "pyright",
            cmd = {"pyright-langserver", "--stdio"},
            root_dir = root_dir,
            capabilities = capabilities,
            settings = {python = {pythonPath = get_python_path()}}
        })
    end

    -- Auto-attach Pyright when opening Python files
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.py",
        callback = function() setup_pyright() end
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "sh,zsh",
        callback = function()
            vim.lsp.start({
                name = "bash-language-server",
                cmd = {"bash-language-server", "start"},
                capabilities = capabilities
            })
        end
    })

    -- TODO: cmp section coupled to LSP, figure out how to separate out the cmp
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Default settings
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body) -- Use LuaSnip for snippets
            end
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        completion = {
            autocomplete = {require('cmp.types').cmp.TriggerEvent.TextChanged}
        },
        sources = cmp.config.sources({
            {name = 'path'}, {name = 'nvim_lsp'}, {name = 'buffer'}
        }),
        mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Select,
                select = true
            }),
            ["<C-Space>"] = cmp.mapping.complete()
        })
    })

    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        -- mapping = custom_cmp_mappings,
        sources = {{name = 'buffer'}}
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        -- mapping = custom_cmp_mappings,
        sources = cmp.config.sources({{name = 'path'}}, {
            {name = 'cmdline', option = {ignore_cmds = {'Man', '!'}}}
        })
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
                -- references = '<cmd>lua require("telescope.builtin").lsp_references()<CR><ESC>'
                references = telescope.lsp_references
                implementations = telescope.lsp_implementations
                workspace_symbols = telescope.lsp_workspace_symbols
                document_symbols = telescope.lsp_document_symbols
            end

            local opts = {buffer = ev.buf}
            vim.keymap.set("n", "gd", definitions)
            vim.keymap.set("n", "gD", declarations)
            vim.keymap.set("n", "gr", references)
            vim.keymap.set("n", "gi", implementations)
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
                vim.api.nvim_win_set_option(0, "winblend", 10)
            end, opts)
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
        end
    })

    function setup_default(lsp_config_name)
        local config = lsp_config[lsp_config_name]
        if config and type(config) == "table" and type(config["setup"]) ==
            "function" then config.setup {capabilities = capabilities} end
    end

    function setup_csharp_ls()
        lsp_config.csharp_ls.setup({
            filetypes = {"cs"},
            capabilities = capabilities,
            root_dir = function(startpath)
                local cwd = vim.fn.getcwd()
                return lsp_config.util.root_pattern("*.sln")(cwd) or
                           lsp_config.util.root_pattern("*.sln")(startpath) or
                           lsp_config.util.root_pattern("*.csproj")(cwd) or
                           lsp_config.util.root_pattern("*.csproj")(startpath) or
                           lsp_config.util.root_pattern("*.fsproj")(cwd) or
                           lsp_config.util.root_pattern("*.fsproj")(startpath) or
                           lsp_config.util.root_pattern(".git")(startpath)
            end
        })
    end

    function setup_ts_ls()
        lsp_config.ts_ls.setup({
            capabilities = capabilities,
            filetypes = {"typescript", "javascript"}
        })
    end

    function setup_volar()
        lsp_config.volar.setup({
            capabilities = capabilities,
            filetypes = {
                "typescript", "javascript", "javascriptreact",
                "typescriptreact", "vue", "json"
            }
        })
    end

    function setup_vuels()
        lsp_config.vuels.setup({
            capabilities = capabilities,
            filetypes = {
                "typescript", "javascript", "javascriptreact",
                "typescriptreact", "vue", "json"
            }
        })
    end

    function setup_tailwindcss()
        lsp_config.vuels.setup({
            capabilities = capabilities,
            filetypes = {
                "typescript", "javascript", "javascriptreact",
                "typescriptreact", "vue", "json"
            }
        })
    end

    function setup_lua_ls()
        lsp_config.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {version = 'LuaJIT'},
                    diagnostics = {globals = {'vim'}},
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    },
                    telemetry = {enable = false}
                }
            }
        })
    end

    function setup_graphql()
        lsp_config.graphql.setup({
            capabilities = capabilities,
            filetypes = {"graphql"}
        })
    end

    local lsp_config_custom = {
        ["csharp_ls"] = setup_csharp_ls,
        ["ts_ls"] = setup_ts_ls,
        ["volar"] = setup_volar,
        ["vuels"] = setup_vuels,
        ["tailwindcss"] = setup_tailwindcss,
        ["lua_ls"] = setup_lua_ls,
        ["graphql"] = setup_graphql
    }

    local lsp_configs_skipped = {pyright = true, bashls = true}
    for _, lsp_name in pairs(mason_lsp_config.get_installed_servers()) do
        local function loop_body()
            if lsp_configs_skipped[lsp_name] then return end
            local setup_function = lsp_config_custom[lsp_name]
            if setup_function then
                setup_function()
            else
                setup_default(lsp_name)
            end
        end
        loop_body()
    end

    vim.diagnostic.config({virtual_text = true})
   
    vim.keymap.set("n", "<leader>ds", function()
      local diags = vim.diagnostic.get(0, {lnum = vim.fn.line('.')-1})
      for _, d in ipairs(diags) do
        print("Message: " .. d.message .. " | Source: " .. (d.source or "unknown"))
      end
    end)

end

return {
    {
        "neovim/nvim-lspconfig",
        version = "*",
        dependencies = {
            -- LSP Support
            {"williamboman/mason.nvim"}, {"williamboman/mason-lspconfig.nvim"}, -- Autocompletion
            {"hrsh7th/nvim-cmp"}, {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-path"},
            {"hrsh7th/cmp-cmdline"}, {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-nvim-lua"}, -- Snippets
            {"L3MON4D3/LuaSnip"}, {"rafamadriz/friendly-snippets"},

            -- nvim-lsp-file-operations
            {"antosha417/nvim-lsp-file-operations"}, {"nvim-lua/plenary.nvim"},
            {"nvim-tree/nvim-tree.lua"}
        },
        config = setup_all_lsps
    }
}
