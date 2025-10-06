local M = {}
local projectTermMap = {}
local extraTermMap = {}
local debugTerminalMap = {}
local terminalJobIdMap = {}
local lastOpenedTermBuf = nil

local function open_terminal_buffer(bufId, opts)
    opts = opts or {}
    local change_cwd_to_current = opts.change_cwd_to_current or false
    local set_to_insert_mode = opts.set_to_insert_mode or false

    -- Get the directory to open the terminal in from current buffer
    -- Won't matter if we are not opening a new terminal
    local terminal_directory = vim.api.nvim_call_function("getcwd", {})
    if change_cwd_to_current then
        terminal_directory = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':h')
    end

    local open_term_buf = function(id)
        if bufId == nil then
            vim.cmd("lcd " .. terminal_directory)
            vim.cmd("terminal")
        else
            vim.cmd("b " .. id)
        end

        -- if set_to_insert_mode then vim.cmd('startinsert') end
        vim.cmd("norm a")
        lastOpenedTermBuf = vim.api.nvim_get_current_buf()
        terminalJobIdMap[lastOpenedTermBuf] = vim.bo.channel
        return lastOpenedTermBuf
    end

    local tabpage = vim.api.nvim_get_current_tabpage()
    local windows_in_tab = vim.api.nvim_tabpage_list_wins(tabpage)
    local currentBuf = vim.api.nvim_get_current_buf()

    -- If the current buffer is any other terminal in the tab, then replace the current buffer with the terminal
    for _, window in pairs(windows_in_tab) do
        local currWinBuf = vim.api.nvim_win_get_buf(window)
        local bufIsTerminal =
            vim.api.nvim_buf_get_option(currWinBuf, "buftype") == "terminal"
        if bufIsTerminal then
            -- If the current buffer is the terminal buffer, then we actually want to close the terminal
            if currWinBuf == currentBuf then
                send_keys("a<C-\\><C-n><C-w>c")
                return
            end
            vim.api.nvim_set_current_win(window)
            return open_term_buf(bufId)
        end
    end

    -- Or else create a new split pane with a small height and go into terminal mode
    vim.cmd("rightb new")
    vim.api.nvim_win_set_height(0, 20)
    return open_term_buf(bufId)
end

function M.open_terminal(termId)
    if extraTermMap[termId] then
        return open_terminal_buffer(extraTermMap[termId])
    else
        local bufId = open_terminal_buffer(nil, {change_cwd_to_current = true})
        extraTermMap[termId] = bufId
        return bufId
    end
end

function M.open_debug_terminal_for_current_file()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    if debugTerminalMap[debugFile] then
        return open_terminal_buffer(debugTerminalMap[debugFile])
    else
        local bufId = open_terminal_buffer(nil, {change_cwd_to_current = true})
        debugTerminalMap[debugFile] = bufId
        return bufId
    end
end

function M.open_project_terminal()
    local current_directory = vim.api.nvim_call_function("getcwd", {})
    local current_directory_name = vim.api.nvim_call_function("fnamemodify", {
        current_directory, ":t"
    })

    if projectTermMap[current_directory_name] then
        open_terminal_buffer(projectTermMap[current_directory_name])
    else
        local bufId = open_terminal_buffer(nil, {change_cwd_to_current = false})
        projectTermMap[current_directory_name] = bufId
    end
end

function M.delete_project_terminal_if_exists(directory_name)
    local bufId = projectTermMap[directory_name]
    if not bufId then
        -- Nothing to delete
        return
    end

    projectTermMap[directory_name] = nil
    vim.api.nvim_buf_delete(bufId, {force = true})
end

local function send_text_to_last_opened_terminal(text)
    if not lastOpenedTermBuf then return end
    local termJobId = terminalJobIdMap[lastOpenedTermBuf]
    if not termJobId then
        error("No terminal job id found for last opened terminal")
    end
    open_terminal_buffer(lastOpenedTermBuf, {set_to_insert_mode = true})
    vim.fn.chansend(termJobId, text)
end

function M.send_clipboard_to_last_opened_terminal()
    local text = vim.fn.getreg('+')
    send_text_to_last_opened_terminal(text)
end

function M.send_visual_selection_to_last_opened_terminal()
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' and mode ~= '' then
        return nil, "Not in visual mode"
    end
    local text = get_visual_selection_and_exit_visual()
    send_text_to_last_opened_terminal(text)
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local terminal_group = augroup("Terminal", {})

local function stop_all_running_terminal_jobs()
    for buf, job_id in pairs(terminalJobIdMap) do
        if vim.fn.jobwait({job_id}, 0)[1] == -1 then -- Check if the job is still running
            vim.fn.jobstop(job_id)
        end
    end
end

autocmd("ExitPre", {
    group = terminal_group,
    pattern = "*",
    callback = function() stop_all_running_terminal_jobs() end
})

return M

