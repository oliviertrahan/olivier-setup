local function nvim_tree_setup()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrw_plugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
            return {
                desc = "nvim-tree: " .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true
            }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set("n", "H", "Hzz", opts('Up'))
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '<C-p>', api.tree.change_root_to_node, opts('Up'))
    end

    -- OR setup with some options
    require("nvim-tree").setup({
        sort_by = "case_sensitive",
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
        update_focused_file = {enable = true},
        view = {width = 30},
        renderer = {group_empty = true},
        filters = {dotfiles = false},
        on_attach = my_on_attach
    })

    -- I use oil.nvim for file management, so I don't need these mappings normally
    -- I will simply use these commands manually if I ever want a tree view
    vim.keymap.set("n", "<leader>go", "<cmd>NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>gf", "<cmd>NvimTreeFindFile<CR>")
    -- vim.keymap.set("n", "<leader>gt", "<cmd>NvimTreeToggle<CR>")
    -- vim.keymap.set("n", "<leader>gc", "<cmd>NvimTreeCollapse<CR>")
end

return {
    {
        'nvim-tree/nvim-tree.lua',
        name = 'nvim-tree',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = nvim_tree_setup
    }
}
