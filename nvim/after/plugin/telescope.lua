---@diagnostic disable: undefined-global
local telescope = require('telescope')
local actions = require('telescope.actions')
local standardize_url = require('o_utils').standardize_url

telescope.setup {
    defaults = {
        initial_mode = "insert",
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
            }
        }
    },
    pickers = {
        find_files = {
            hidden = true
        },
        buffers = {
            mappings = {
                i = {
                    ['<C-d>'] = actions.delete_buffer
                },
                n = {
                    ['<C-d>'] = actions.delete_buffer
                }
            }
        }
    }
}

local builtin = require('telescope.builtin')

local find_standard_params = {'rg', '--files', '--hidden', '--smart-case', '-g', '!.git' }
local find_include_gitignore_params = {'rg', '--files', '--hidden', '-u', '--smart-case', '-g', '!.git' }

local find_standard = function() builtin.find_files({ find_command = find_standard_params }) end
local find_include_gitignore = function() builtin.find_files({ find_command = find_include_gitignore_params }) end

vim.keymap.set('n', '<leader>ff', find_standard, {})
vim.keymap.set('n', '<leader>fhf', find_include_gitignore, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', function() builtin.oldfiles{ only_cwd = true } end, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fwr', builtin.oldfiles, {})

local function get_working_directories()
    local tabpages = vim.api.nvim_list_tabpages()
    local working_directories = {}
    for _, tabpage in pairs(tabpages) do
        local tabnum = vim.api.nvim_tabpage_get_number(tabpage)
        local current_directory = vim.api.nvim_call_function("getcwd", {-1, tabnum})
        table.insert(working_directories, current_directory)
    end
    return working_directories
end

vim.keymap.set('n', '<leader>fwf', function()
    builtin.find_files{ find_command = find_standard_params, search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fwhf', function()
    builtin.find_files{ find_command = find_include_gitignore_params, search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fhwf', function()
    builtin.find_files{ find_command = find_include_gitignore_params, search_dirs = get_working_directories() }
end, {})

vim.keymap.set('n', '<leader>fwg', function()
    builtin.live_grep{ search_dirs = get_working_directories() }
end, {})

vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

