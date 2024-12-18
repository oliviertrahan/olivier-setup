vim.g.print_remap_func = {}

local exports = {}
local projectTermMap = {}
local extraTermMap = {}
local debugTerminalMap = {}
local debugOutputMap = {}
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
	cs = function(fileName)
		return { "dotnet", "run", fileName }
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
		return { "nvim", "--headless", "-c", "source " .. fileName .. " | qa!" }
	end,
}

local function send_keys(keys_to_send)
    local keys = vim.api.nvim_replace_termcodes(keys_to_send, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end

local function delete_project_terminal_if_exists(directory_name)
    local bufId = projectTermMap[directory_name]
    if not bufId then
        --Nothing to delete
        return
    end

    projectTermMap[directory_name] = nil
    vim.api.nvim_buf_delete(bufId, { force = true })
end

local function checkout_branch(branch)
    if not branch or #branch == 0 then
        return
    end
    branch = branch[1]
    local branch_local_name = branch:gsub("^[%s]*origin/", "")
    local curr_dir_full_path = vim.fn.getcwd()
    local current_directory_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local review_directory_name = string.format("%s-review", current_directory_name)
    local git_worktree_path = string.format("../%s", review_directory_name)
    local git_worktree_remove_command = string.format("git worktree remove %s", git_worktree_path)
    local git_worktree_command = string.format("git worktree add -f %s %s", git_worktree_path, branch_local_name)
    vim.fn.system(git_worktree_remove_command)
    vim.fn.system(git_worktree_command)
    --terminal will be in a bad state if we don't delete the project terminal
    delete_project_terminal_if_exists(review_directory_name)
    local tcd_path = string.format("%s/%s", curr_dir_full_path, git_worktree_path)
    vim.cmd("tabnew")
    vim.cmd(string.format("tcd %s", tcd_path))
end

local fzf = require('fzf-lua')
function exports.setup_review_branch()
  --Get git branches that includes origin remote, sorted by earliest
  local results = vim.fn.systemlist("git --no-pager branch -lr --sort=-committerdate")
  fzf.fzf_exec(results, {
    prompt = 'Select Branch > ',
    cwd = vim.fn.getcwd(), -- Set current working directory
    previewer = false,      -- Enable previewer
    actions = {
      -- What to do with the selected item
      ['default'] = checkout_branch
    },
  })
end

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

-- return true if the terminal just opened
function exports.open_terminal(termId)
	if extraTermMap[termId] then
		open_terminal_buffer(extraTermMap[termId])
        return false
	else
		local bufId = open_terminal_buffer(nil)
		extraTermMap[termId] = bufId
        return true
	end
end

function exports.open_debug_terminal()
    local debugFile = vim.fn.expand("%:p") -- full path from root
	if debugTerminalMap[debugFile] then
		open_terminal_buffer(debugTerminalMap[debugFile])
        return false
	else
		local bufId = open_terminal_buffer(nil)
		debugTerminalMap[debugFile] = bufId
        return true
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
	local format = kwargs.format
	local buffer = kwargs.buffer

	local delete_op = is_visual and "c" or "o"
	local keymap_mode = is_visual and "v" or "n"
	local keymap = is_json and "<leader>sjp" or "<leader>sp"
	local func_id = uuid()
	local remap_func_tab = vim.g.print_remap_func
	remap_func_tab[func_id] = function()
		local copyVal = vim.fn.getreg('"')
		local formattedInsert = interp(format, { copy = copyVal })
		vim.fn.setreg("x", formattedInsert)
	end
	vim.g.print_remap_func = remap_func_tab
	local remap_str = string.format("%s<cmd>lua vim.g.print_remap_func['%s']()<CR><C-r>x<ESC>", delete_op, func_id)
	local opts = {}
	if buffer then
		opts.buffer = buffer
	end
	vim.keymap.set(keymap_mode, keymap, remap_str, opts)
end

local function run_external_command_and_print_output(command, debugFile)
    local debugOutBuf = debugOutputMap[debugFile]
    if not debugOutBuf then
        error("debugOutBuf cannot be nil")
    end
	-- Clear the buffer
	local line_count = vim.api.nvim_buf_line_count(debugOutBuf)
    -- local current_line_count = 0
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
		end,
	})
end

function exports.run_command_in_debug_terminal()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    local debugFileType = vim.fn.expand("%:e")
    local commandFunc = debugFileTypeToCommand[debugFileType]
    if commandFunc == nil then
        return
    end

    --If we had a regular debug buffer, then we remove it
    local debugOutBuf = debugOutputMap[debugFile]
    if debugOutBuf then
        exports.cancel_debug_buffer()
    end

    -- enter debug terminal whether old or new
    local terminalId = debugTerminalMap[debugFile]
    terminalId = open_terminal_buffer(terminalId)
    debugTerminalMap[debugFile] = terminalId
    local command = commandFunc(debugFile)
    for _, cmd in ipairs(command) do
        vim.api.nvim_feedkeys(cmd .. " ", "n", true)
    end
    send_keys("<CR>")
end

function exports.cancel_debug_buffer()
	local debugFile = vim.fn.expand("%:p") -- full path from root
    debugOutputMap[debugFile] = nil
    vim.api.nvim_del_augroup_by_name("DebugBuffer")
    vim.print("Debug buffer cleared")
end

function exports.create_debug_buffer()
	local debugFile = vim.fn.expand("%:p") -- full path from root
	local debugFilePattern = vim.fn.expand("%") -- path relative to working directory
	local currentWin = vim.api.nvim_get_current_win()
	vim.cmd("rightb new")
    debugOutputMap[debugFile] = vim.api.nvim_get_current_buf()
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
			run_external_command_and_print_output(command, debugFile)
		end,
	})
end

return exports
