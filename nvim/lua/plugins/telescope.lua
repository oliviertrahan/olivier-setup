local function setup_telescope()
    ---@diagnostic disable: undefined-global
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup {
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-c>"] = actions.close,
                },
                n = {
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["H"] = actions.results_scrolling_up,
                    ["L"] = actions.results_scrolling_down,
                    ["<C-c>"] = actions.close,
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
    local find_standard_params = { 'rg', '--files', '--hidden', '--smart-case', '-g', '!.git' }
    local find_include_gitignore_params = { 'rg', '--files', '--hidden', '-u', '--smart-case', '-g', '!.git' }

    local find_standard = function() builtin.find_files({ find_command = find_standard_params }) end
    local find_include_gitignore = function() builtin.find_files({ find_command = find_include_gitignore_params }) end

    vim.keymap.set('n', '<leader>ff', find_standard, {})
    vim.keymap.set('n', '<leader>fhf', find_include_gitignore, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fr', function() builtin.oldfiles { only_cwd = true } end, {})
    vim.keymap.set('n', '<leader>fd', builtin.help_tags, {})
    vim.keymap.set('v', '<leader>fd', 'y<cmd>Telescope help_tags<CR><C-r>"', {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('v', '<leader>fg', function()
        vim.cmd('norm! y')
        builtin.grep_string { search = vim.fn.getreg('"') }
    end, {})
    -- vim.keymap.set('n', '<leader>fcg', function() builtin.live_grep{ search_dirs = {vim.fn.expand("%:p")}} end, {})
    vim.keymap.set('n', '<leader>fcg', '<cmd>Telescope current_buffer_fuzzy_find<CR>', {})
    vim.keymap.set('v', '<leader>fcg', 'y<cmd>Telescope current_buffer_fuzzy_find<CR><C-r>"', {})
    vim.keymap.set('n', '<leader>fyg', 'yiw<cmd>Telescope live_grep<CR><C-r>"', {})

    local function get_working_directories()
        local tabpages = vim.api.nvim_list_tabpages()
        local working_directories = {}
        for _, tabpage in pairs(tabpages) do
            local tabnum = vim.api.nvim_tabpage_get_number(tabpage)
            local current_directory = vim.api.nvim_call_function("getcwd", { -1, tabnum })
            table.insert(working_directories, current_directory)
        end
        return working_directories
    end

    vim.keymap.set('n', '<leader>fwf', function()
        builtin.find_files { find_command = find_standard_params, search_dirs = get_working_directories() }
    end, {})
    vim.keymap.set('n', '<leader>fwhf', function()
        builtin.find_files { find_command = find_include_gitignore_params, search_dirs = get_working_directories() }
    end, {})
    vim.keymap.set('n', '<leader>fhwf', function()
        builtin.find_files { find_command = find_include_gitignore_params, search_dirs = get_working_directories() }
    end, {})

    vim.keymap.set('n', '<leader>fwg', function()
        builtin.live_grep { search_dirs = get_working_directories() }
    end, {})

    vim.keymap.set('v', '<leader>fwg', function()
        vim.cmd('norm! y')
        builtin.grep_string { search_dirs = get_working_directories(), search = vim.fn.getreg('"') }
    end, {})

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
end

return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.4',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { { 'nvim-telescope/telescope.nvim' } },
        config = setup_telescope
    },
}
