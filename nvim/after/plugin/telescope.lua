local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('project')
local project_actions = require("telescope._extensions.project.actions")

telescope.setup {
    defaults = {
        -- initial_mode = "normal",
        initial_mode = "insert",
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ['<C-d>'] = actions.delete_buffer
            },
            n = {
                ['<C-d>'] = actions.delete_buffer
            }
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        project = {
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true,
            on_project_selected = function(prompt_bufnr)
                project_actions.change_working_directory(prompt_bufnr, false)
                local current_directory = vim.api.nvim_call_function("getcwd", {})
                vim.cmd(string.format('silent! tcd %s', current_directory))
                local curr_dir_name = vim.api.nvim_call_function("fnamemodify", {current_directory, ":t"})
                vim.cmd(string.format('silent! TabooRename %s', curr_dir_name))
            end
        }
    }
}

local function get_working_directories()
    local tabpages = vim.api.nvim_list_tabpages()
    local working_directories = {}
    for _, tab in pairs(tabpages) do
        local current_directory = vim.api.nvim_call_function("getcwd", {-1, tab})
        table.insert(working_directories, current_directory)
    end
    return working_directories
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}) end, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fp', function() telescope.extensions.project.project{} end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fwf', function()
    builtin.find_files{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fwg', function()
    builtin.live_grep{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

