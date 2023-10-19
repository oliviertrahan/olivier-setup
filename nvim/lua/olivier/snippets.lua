
local augroup = vim.api.nvim_create_augroup
local deleteAugroup = vim.api.nvim_del_augroup_by_name
local autocmd = vim.api.nvim_create_autocmd

local snippets = {
    {
        command_nemonic = 'e',
        snippet_file = 'example.txt',
        steps = {
            'jA',
            'j_f\'l',
            'llf\'l',
            'llf\'l'
        }
    },
    {
        command_nemonic = 'fi',
        snippet_file = 'for_i.txt',
        steps = {
            'f;',
            'llf;',
            'jA'
        }
    },
    {
        command_nemonic = 'fe',
        snippet_file = 'foreach.txt',
        steps = {
            'fr;ll',
            'f)',
            'jA'
        }
    }
}

local function execute_step(step)
    if type(step) == 'string' then
        vim.cmd('norm ' .. step)
    elseif type(step) == 'function' then
        step()
    end
    vim.cmd('startinsert')
end


function AddSnippets(snippet_list)
    for _, snippet in ipairs(snippet_list) do
        local keymap = '<leader>s' .. snippet.command_nemonic
        local snippet_file = snippet.snippet_file
        local snippet_file_path = string.format('~/.config/nvim/snippets/%s', snippet_file)

        local command_func = function()
            vim.cmd('-1read ' .. snippet_file_path)
            execute_step(snippet.steps[1])

            local step_count = 2
            local snippet_au_name = string.format('snippet_%s', snippet.snippet_file)

            if #snippet.steps > 1 then
                augroup(snippet_au_name, {})
                autocmd({"InsertLeave"}, {
                    group = snippet_au_name,
                    pattern = "*",
                    callback = function()
                        if step_count <= #snippet.steps then
                            execute_step(snippet.steps[step_count])
                            step_count = step_count + 1
                        else
                            deleteAugroup(snippet_au_name)
                        end
                    end
                })
            end
        end

        vim.keymap.set('n', keymap, command_func)
    end
end


AddSnippets(snippets)
