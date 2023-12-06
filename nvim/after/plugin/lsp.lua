local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
    'csharp_ls',
    'eslint',
    'vls',
    'bashls',
    'lua_ls'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh,zsh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local definitions = vim.lsp.buf.definition
        local declarations = vim.lsp.buf.declaration
        local references = vim.lsp.buf.references
        local implementations = vim.lsp.buf.implementation
        local workspace_symbols = vim.lsp.buf.workspace_symbol
        local document_symbols = vim.lsp.buf.document_symbol

        local telescope = require('telescope.builtin')
        if telescope then
            definitions = telescope.lsp_definitions
            references = telescope.lsp_references
            implementations = telescope.lsp_implementations
            workspace_symbols = telescope.lsp_workspace_symbols
            document_symbols = telescope.lsp_document_symbols
        end

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", function()
            definitions()
            vim.cmd("norm zz")
        end, opts)
        vim.keymap.set("n", "gD", function()
            declarations()
            vim.cmd("norm zz")
        end, opts)
        vim.keymap.set("n", "gr", function()
            references()
            vim.cmd("norm zz")
        end, opts)
        vim.keymap.set("n", "gi", function()
            implementations()
            vim.cmd("norm zz")
        end, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "=", vim.lsp.buf.format, opts)
        vim.keymap.set("n", "<leader>vws", workspace_symbols, opts)
        vim.keymap.set("n", "<leader>vds", document_symbols, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("v", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>vh", vim.lsp.buf.signature_help, opts)
    end
})

lsp.setup()

local lsp_config = require('lspconfig')

lsp_config.csharp_ls.setup({
    root_dir = function(startpath)
        local cwd = vim.fn.getcwd()
        return lsp_config.util.root_pattern("*.sln")(cwd)
        	or lsp_config.util.root_pattern("*.sln")(startpath)
            or lsp_config.util.root_pattern("*.csproj")(startpath)
            or lsp_config.util.root_pattern("*.fsproj")(startpath)
            or lsp_config.util.root_pattern(".git")(startpath)
    end
})


--eslint LSP attaches formatting command, use it
lsp_config.eslint.setup({
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
})

vim.diagnostic.config({
    virtual_text = true
})

