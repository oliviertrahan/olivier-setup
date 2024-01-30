local exports = {}
local projectTermMap = {}
local extraTermMap = {}

local function open_terminal_buffer(bufId)
    local open_term_buf = function(id)
        if bufId == nil then
            vim.cmd("terminal")
        else
            vim.cmd("b " .. id)
        end

        vim.cmd("norm a")
        return vim.api.nvim_get_current_buf()
    end

    local tabpage = vim.api.nvim_get_current_tabpage()
    local windows_in_tab = vim.api.nvim_tabpage_list_wins(tabpage)

    --If the current buffer is any other terminal in the tab, then replace the current buffer with the terminal
    for _, window in pairs(windows_in_tab) do
        local currWinBuf = vim.api.nvim_win_get_buf(window)
        if vim.api.nvim_buf_get_option(currWinBuf, "buftype") == "terminal" then
            vim.api.nvim_set_current_win(window)
            return open_term_buf(bufId)
        end
    end

    --Or else create a new split pane and go into terminal mode
    vim.cmd("rightb new")
    return open_term_buf(bufId)
end

function exports.open_terminal(termId)
    if extraTermMap[termId] then
        open_terminal_buffer(extraTermMap[termId])
    else
        local bufId = open_terminal_buffer(nil)
        extraTermMap[termId] = bufId
    end
end

function exports.open_project_terminal()
    local current_directory = vim.api.nvim_call_function("getcwd", {})
    local current_directory_name = vim.api.nvim_call_function("fnamemodify", { current_directory, ":t" })

    if projectTermMap[current_directory_name] then
        open_terminal_buffer(projectTermMap[current_directory_name])
    else
        local bufId = open_terminal_buffer(nil)
        projectTermMap[current_directory_name] = bufId
    end
end

function exports.set_print_snippet(is_visual, is_json, prefix, midfix, postfix, buffer)
    local delete_op = is_visual and 'c' or 'i'
    local keymap_mode = is_visual and 'v' or 'n'
    local keymap = is_json and '<leader>sjp' or '<leader>sp'
    local remap_str = delete_op .. prefix .. "<C-r>\"" .. midfix .. "<C-r>\"" .. postfix .. "<C-c>"
    local opts = {}
    if buffer then
        opts.buffer = buffer
    end
    vim.keymap.set(keymap_mode, keymap, remap_str, opts)
end

return exports
