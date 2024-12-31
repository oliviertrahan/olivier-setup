local M = {}
local projectTermMap = {}
local extraTermMap = {}
local debugTerminalMap = {}

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
	local currentBuf = vim.api.nvim_get_current_buf()

	--If the current buffer is any other terminal in the tab, then replace the current buffer with the terminal
	for _, window in pairs(windows_in_tab) do
		local currWinBuf = vim.api.nvim_win_get_buf(window)
		local bufIsTerminal = vim.api.nvim_buf_get_option(currWinBuf, "buftype") == "terminal"
		if bufIsTerminal then
			--If the current buffer is the terminal buffer, then we actually want to close the terminal
			if currWinBuf == currentBuf then
                send_keys("a<C-\\><C-n><C-w>c")
				return
			end
			vim.api.nvim_set_current_win(window)
			return open_term_buf(bufId)
		end
	end

	--Or else create a new split pane and go into terminal mode
	vim.cmd("rightb new")
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
	local current_directory_name = vim.api.nvim_call_function("fnamemodify", { current_directory, ":t" })

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
        --Nothing to delete
        return
    end

    projectTermMap[directory_name] = nil
    vim.api.nvim_buf_delete(bufId, { force = true })
end

return M

