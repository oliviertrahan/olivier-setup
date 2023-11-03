local telescope = require('telescope')
local actions = require('telescope.actions')

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
vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ find_command = {'rg', '--files', '--hidden', '--smart-case', '-g', '!.git' }}) end, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fwf', function()
    builtin.find_files{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fwg', function()
    builtin.live_grep{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

