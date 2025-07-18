local M = {}
local projectTermMap = {}
local extraTermMap = {}
local debugTerminalMap = {}
local terminalJobIdMap = {}
local lastOpenedTermBuf = nil

local function open_terminal_buffer(bufId)
    local open_term_buf = function(id)
        if bufId == nil then
            vim.cmd("terminal")
        else
            vim.cmd("b " .. id)
        end

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
        local bufId = open_terminal_buffer(nil)
        extraTermMap[termId] = bufId
        return bufId
    end
end

function M.open_debug_terminal_for_current_file()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    if debugTerminalMap[debugFile] then
        return open_terminal_buffer(debugTerminalMap[debugFile])
    else
        local bufId = open_terminal_buffer(nil)
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
        local bufId = open_terminal_buffer(nil)
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

function M.send_visual_selection_to_last_opened_terminal()
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' and mode ~= '' then
        return nil, "Not in visual mode"
    end

    if not lastOpenedTermBuf then return end

    local termJobId = terminalJobIdMap[lastOpenedTermBuf]
    if not termJobId then
        error("No terminal job id found for last opened terminal")
    end
    local text = get_visual_selection()
    vim.print("text: " .. text)
    vim.fn.chansend(termJobId, text)
    open_terminal_buffer(lastOpenedTermBuf)
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local terminal_group = augroup("Terminal", {})

function stop_all_running_terminal_jobs()
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

