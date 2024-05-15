local exports = {}
local projectTermMap = {}
local extraTermMap = {}
local debugOutBuf = nil
local debugFileTypeToCommand = {
    go = function(fileName)
        return { "go", "run", fileName }
    end,
    sh = function(fileName)
        return { "sh", fileName }
    end,
    zsh = function(fileName)
        return { "zsh", fileName }
    end,
    py = function(fileName)
        return { "python3", fileName }
    end,
    js = function(fileName)
        return { "node", fileName }
    end,
    mjs = function(fileName)
        return { "node", fileName }
    end,
    cjs = function(fileName)
        return { "node", fileName }
    end,
    lua = function(fileName)
        return { "nvim", "--headless", "-c", 'source ' .. fileName .. ' | qa!' }
    end,
}

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


function exports.set_print_snippet(kwargs)
    local is_visual = kwargs.is_visual
    local is_json = kwargs.is_json
    local prefix = kwargs.prefix
    local midfix = kwargs.midfix
    local postfix = kwargs.postfix
    local buffer = kwargs.buffer

    local copyVal = vim.fn.getreg('"')


    
    local delete_op = is_visual and 'c' or 'o'
    local keymap_mode = is_visual and 'v' or 'n'
    local keymap = is_json and '<leader>sjp' or '<leader>sp'
    local remap_str = delete_op .. prefix .. "<C-r>\"" .. midfix .. "<C-r>\"" .. postfix .. "<C-c>"
    local opts = {}
    if buffer then
        opts.buffer = buffer
    end
    vim.keymap.set(keymap_mode, keymap, remap_str, opts)
end


-- function exports.set_print_snippet(is_visual, is_json, prefix, midfix, postfix, buffer)
--     local delete_op = is_visual and 'c' or 'o'
--     local keymap_mode = is_visual and 'v' or 'n'
--     local keymap = is_json and '<leader>sjp' or '<leader>sp'
--     local remap_str = delete_op .. prefix .. "<C-r>\"" .. midfix .. "<C-r>\"" .. postfix .. "<C-c>"
--     local opts = {}
--     if buffer then
--         opts.buffer = buffer
--     end
--     vim.keymap.set(keymap_mode, keymap, remap_str, opts)
-- end

---@diagnostic disable-next-line: duplicate-set-field
function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end


function run_external_command_and_print_output(command)
    -- Clear the buffer
    local line_count = vim.api.nvim_buf_line_count(debugOutBuf)
    vim.api.nvim_buf_set_lines(debugOutBuf, 0, line_count, false, {})

    vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = function(_, data, _)
            if data then
                vim.api.nvim_buf_set_lines(debugOutBuf, -1, -1, false, data)
            end
        end,
        on_stderr = function(_, data, _)
            if data then
                vim.api.nvim_buf_set_lines(debugOutBuf, -1, -1, false, data)
            end
        end
    })
end

function exports.create_debug_buffer()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    local debugFilePattern = vim.fn.expand("%") -- path relative to working directory
    local currentWin = vim.api.nvim_get_current_win()
    vim.cmd("rightb new")
    debugOutBuf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_win(currentWin)

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("DebugBuffer", { clear = true }),
        pattern = debugFilePattern,
        callback = function()
            local debugFileType = vim.fn.expand("%:e")
            local commandFunc = debugFileTypeToCommand[debugFileType]
            if commandFunc == nil then
                return
            end
            local command = commandFunc(debugFile)
            run_external_command_and_print_output(command)
        end
    })
end


return exports
