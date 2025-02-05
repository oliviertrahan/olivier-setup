vim.g.print_remap_func = {}

local terminal_functions = require('setup.terminal_functions')
local delete_project_terminal_if_exists = terminal_functions.delete_project_terminal_if_exists

local M = {}
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

local function git_worktree_remove_command(directory_path)
    vim.fn.system(string.format("git worktree remove %s", directory_path))
end

function M.delete_tab_cwd()
    local current_directory = vim.fn.getcwd()
    if not current_directory then
        print("Current directory not present. Delete.")
        return
    end

    local answer = vim.fn.input(string.format("Delete tab cwd \"%s\"? (y/n): ", current_directory))
    if answer == "y" then
        vim.fn.system(string.format("rm -rf %s", current_directory))
        git_worktree_remove_command(current_directory)
        vim.cmd("tabclose")
    end
end

local function get_review_directory_name(curr_dir_full_path)
    if not curr_dir_full_path then
        curr_dir_full_path = vim.fn.getcwd()
    end
    local current_directory_name = vim.fn.fnamemodify(curr_dir_full_path, ":t")
    return string.format("%s-review", current_directory_name)
end

local function get_relative_review_directory_path(review_directory_name)
    if not review_directory_name then
        review_directory_name = get_review_directory_name()
    end
    return string.format("../%s", review_directory_name)
end

local function get_absolute_review_directory_path(curr_dir_full_path, review_directory_path)
    if not curr_dir_full_path then
        curr_dir_full_path = vim.fn.getcwd()
    end
    if not review_directory_path then
        review_directory_path = get_relative_review_directory_path()
    end
    return string.format("%s/%s", curr_dir_full_path, review_directory_path)
end

local function open_review_branch_and_checkout(branch_local_name)
    local curr_dir_full_path = vim.fn.getcwd()
    local review_directory_name = get_review_directory_name(curr_dir_full_path)
    local review_directory_path = get_relative_review_directory_path(review_directory_name)
    if branch_local_name then
        local git_worktree_command = string.format("git worktree add -f %s %s", review_directory_path, branch_local_name)
        git_worktree_remove_command(review_directory_path)
        vim.fn.system(git_worktree_command)
    end
    --terminal will be in a bad state if we don't delete the project terminal
    delete_project_terminal_if_exists(review_directory_name)
    local tcd_path = get_absolute_review_directory_path(curr_dir_full_path, review_directory_path)
    vim.cmd("tabnew")
    vim.cmd(string.format("tcd %s", tcd_path))
end

function M.open_review_branch()
    open_review_branch_and_checkout(nil)
end

function M.delete_review_branch()
    local curr_dir_full_path = vim.fn.getcwd()
    local review_directory_name = get_review_directory_name(curr_dir_full_path)
    local review_directory_path = get_relative_review_directory_path(review_directory_name)
    git_worktree_remove_command(review_directory_path)
    delete_project_terminal_if_exists(review_directory_name)
end

local function checkout_branch(branch)
    if not branch or #branch == 0 then
        return
    end
    branch = branch[1]
    local branch_local_name = branch:gsub("^[%s]*origin/", "")
    open_review_branch_and_checkout(branch_local_name)
end

local fzf = require('fzf-lua')
function M.setup_review_branch()
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

function M.set_print_snippet(kwargs)
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

function M.cancel_debug_buffer()
	local debugFile = vim.fn.expand("%:p") -- full path from root
    debugOutputMap[debugFile] = nil
    vim.api.nvim_del_augroup_by_name("DebugBuffer")
    vim.print("Debug buffer cleared")
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

function M.create_debug_buffer()
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

function M.run_command_in_debug_terminal()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    local debugFileType = vim.fn.expand("%:e")
    local commandFunc = debugFileTypeToCommand[debugFileType]
    if commandFunc == nil then
        return
    end

    --If we had a regular debug buffer, then we remove it
    local debugOutBuf = debugOutputMap[debugFile]
    if debugOutBuf then
        M.cancel_debug_buffer()
    end

    -- enter debug terminal whether old or new
    terminal_functions.open_debug_terminal_for_current_file()
    local command = commandFunc(debugFile)
    for _, cmd in ipairs(command) do
        vim.api.nvim_feedkeys(cmd .. " ", "n", true)
    end
    send_keys("<CR>")
end

M.open_terminal = terminal_functions.open_terminal
M.open_debug_terminal_for_current_file = terminal_functions.open_debug_terminal_for_current_file
M.open_project_terminal = terminal_functions.open_project_terminal
M.send_visual_selection_to_last_opened_terminal = terminal_functions.send_visual_selection_to_last_opened_terminal

return M
