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

local autocmd = vim.api.nvim_create_autocmd
local builtin = require('telescope.builtin')

local find_standard = function() builtin.find_files({ find_command = {'rg', '--files', '--hidden', '--smart-case', '-g', '!.git' }}) end
local find_include_gitignore = function() builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-u', '--smart-case', '-g', '!.git' }}) end

vim.keymap.set('n', '<leader>ff', find_standard, {})

pcall(function() require('not_pushed.telescope') end)

local function telescope_change_search_dirs(directories, win, buf, tab)
    local current_win_directory = vim.api.nvim_call_function("getcwd", {win, tab})
    local found = false
    for _, directory in pairs(directories) do
        if (standardize_url(current_win_directory) == standardize_url(directory)) then
            -- Set search path to ignore, same as default, but adding -u parameter 
            vim.keymap.set('n', '<leader>ff', find_include_gitignore, {buffer = buf})
            found = true
            break
        end
    end
    if (not found) then
    	vim.keymap.set('n', '<leader>ff', find_standard, {buffer = buf})
    end
end

if (directories_to_include_gitignore) then
    for _,win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local tabpage = vim.api.nvim_win_get_tabpage(win)
        telescope_change_search_dirs(directories_to_include_gitignore, win, buf, tabpage)
    end
    autocmd({"BufEnter", "DirChanged"}, {
        pattern = "*",
        callback = function(ev)
            telescope_change_search_dirs(directories_to_include_gitignore,
            	vim.api.nvim_get_current_win(),
                ev.buf,
                vim.api.nvim_get_current_tabpage()
            )
        end
    })
end

vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', function() builtin.oldfiles{ only_cwd = true } end, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fwr', builtin.oldfiles, {})

local function get_working_directories()
    local tabpages = vim.api.nvim_list_tabpages()
    local working_directories = {}
    for _, tab in pairs(tabpages) do
        local current_directory = vim.api.nvim_call_function("getcwd", {-1, tab})
        table.insert(working_directories, current_directory)
    end
    return working_directories
end

vim.keymap.set('n', '<leader>fwf', function()
    builtin.find_files{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>fwg', function()
    builtin.live_grep{ search_dirs = get_working_directories() }
end, {})
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

