local function nvim_tree_setup()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrw_plugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
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
        update_focused_file = {
            enable = true
        },
        view = {
            width = 30
        },
        renderer = {
            group_empty = true
        },
        filters = {
            dotfiles = false
        },
        on_attach = my_on_attach
    })

    vim.keymap.set("n", "<leader>go", "<cmd>NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>gf", "<cmd>NvimTreeFindFile<CR>")
    vim.keymap.set("n", "<leader>gt", "<cmd>NvimTreeToggle<CR>")
    vim.keymap.set("n", "<leader>gc", "<cmd>NvimTreeCollapse<CR>")
end

return {
    {
        'nvim-tree/nvim-tree.lua',
        name = 'nvim-tree',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = nvim_tree_setup
    },
    {
        'nvim-tree/nvim-web-devicons',
        name = 'nvim-devicons',
        config = function()
            require 'nvim-web-devicons'.setup {
                -- your personnal icons can go here (to override)
                -- you can specify color or cterm_color instead of specifying both of them
                -- DevIcon will be appended to `name`
                override = {
                    zsh = {
                        icon = "",
                        color = "#428850",
                        cterm_color = "65",
                        name = "Zsh"
                    }
                },
                -- globally enable different highlight colors per icon (default to true)
                -- if set to false all icons will have the default icon's color
                color_icons = true,
                -- globally enable default icons (default to false)
                -- will get overriden by `get_icons` option
                default = true,
                -- globally enable "strict" selection of icons - icon will be looked up in
                -- different tables, first by filename, and if not found by extension; this
                -- prevents cases when file doesn't have any extension but still gets some icon
                -- because its name happened to match some extension (default to false)
                strict = true,
                -- same as `override` but specifically for overrides by filename
                -- takes effect when `strict` is true
                override_by_filename = {
                    [".gitignore"] = {
                        icon = "",
                        color = "#f1502f",
                        name = "Gitignore"
                    }
                },
                -- same as `override` but specifically for overrides by extension
                -- takes effect when `strict` is true
                override_by_extension = {
                    ["log"] = {
                        icon = "",
                        color = "#81e043",
                        name = "Log"
                    }
                },
            }
        end
    },
}
