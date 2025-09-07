vim.g.print_remap_func = {}

local terminal_functions = require('setup.terminal_functions')
local delete_project_terminal_if_exists =
    terminal_functions.delete_project_terminal_if_exists

local M = {}
local debugOutputMap = {}
local debugFileTypeToCommand = {
    go = function(fileName) return {"go", "run", fileName} end,
    sh = function(fileName) return {"sh", fileName} end,
    zsh = function(fileName) return {"zsh", fileName} end,
    py = function(fileName) return {"python3", fileName} end,
    cs = function(fileName) return {"dotnet", "script", fileName} end,
    js = function(fileName) return {"bun", "run", fileName} end, -- switched from node 
    ts = function(fileName) return {"bun", "run", fileName} end,
    mjs = function(fileName) return {"bun", "run", fileName} end,
    cjs = function(fileName) return {"bun", "run", fileName} end,
    lua = function(fileName)
        return {"nvim", "--headless", "-c", "source " .. fileName .. " | qa!"}
    end
}

function get_macro_register(input_prompt)
    local macro_reg = vim.fn.input(input_prompt)
    if not macro_reg or #macro_reg ~= 1 then
        error("Invalid macro register. Needs to be 1 letter.")
    end
    return macro_reg
end

function M.macro_edit()
    local macro_reg = get_macro_register("Enter macro reg to edit: ")
    local macro_content = vim.fn.getreg(macro_reg)
    if not macro_content or #macro_content == 0 then
        error("Macro register is empty.")
        return
    end
    macro_content = vim.fn.keytrans(macro_content)
    local macro_reg = vim.fn.input("replace macro", macro_content)
    updated_macro = vim.api.nvim_replace_termcodes(updated_macro, true, false,
                                                   true)
    vim.fn.setreg(macro_reg, updated_macro)
    vim.print(string.format("Macro reg \"%s\" updated to \"%s\"", macro_reg,
                            updated_macro))
end

function M.macro_paste()
    local macro_reg = get_macro_register("Enter macro reg to paste: ")
    local macro_content = vim.fn.getreg(macro_reg)
    macro_content = vim.fn.keytrans(macro_content)
    vim.fn.setreg("v", macro_content)
    send_keys("\"vp") -- paste macro
end

function M.macro_update()
    local macro_reg = get_macro_register("Enter macro reg to update: ")
    local new_macro_content = get_visual_selection()
    send_keys("gvd") -- delete visual selection
    new_macro_content = vim.api.nvim_replace_termcodes(new_macro_content, true,
                                                       false, true)
    vim.fn.setreg(macro_reg, new_macro_content)
    vim.print(string.format("Macro reg '%s' updated to '%s'", macro_reg,
                            vim.inspect(new_macro_content)))
end

function replace_visual_selection(replace_func)
    local visual_selection = get_visual_selection()
    send_keys("gv")
    replaced_str = replace_func(visual_selection)
    vim.fn.setreg("v", replaced_str)
    send_keys("\"vp")
end

function M.replace_visual_selection_term_codes_to_macro()
    replace_visual_selection(function(visual_selection)
        return vim.api.nvim_replace_termcodes(visual_selection, true, false,
                                              true)
    end)
end

function M.replace_visual_selection_macro_to_term_codes()
    replace_visual_selection(function(visual_selection)
        return vim.fn.keytrans(visual_selection)
    end)
end

local function git_worktree_remove_command(directory_path)
    vim.fn.system(string.format("git worktree remove %s", directory_path))
end

function M.delete_tab_cwd()
    local current_directory = vim.fn.getcwd()
    if not current_directory then
        print("Current directory not present. Delete.")
        return
    end

    local answer = vim.fn.input(string.format("Delete tab cwd \"%s\"? (y/n): ",
                                              current_directory))
    if answer == "y" then
        vim.fn.system(string.format("rm -rf %s", current_directory))
        git_worktree_remove_command(current_directory)
        vim.cmd("tabclose")
    end
end

local function get_review_directory_name(curr_dir_full_path)
    if not curr_dir_full_path then curr_dir_full_path = vim.fn.getcwd() end
    local current_directory_name = vim.fn.fnamemodify(curr_dir_full_path, ":t")
    return string.format("%s-review", current_directory_name)
end

local function get_relative_review_directory_path(review_directory_name)
    if not review_directory_name then
        review_directory_name = get_review_directory_name()
    end
    return string.format("../%s", review_directory_name)
end

local function get_absolute_review_directory_path(curr_dir_full_path,
                                                  review_directory_path)
    if not curr_dir_full_path then curr_dir_full_path = vim.fn.getcwd() end
    if not review_directory_path then
        review_directory_path = get_relative_review_directory_path()
    end
    return string.format("%s/%s", curr_dir_full_path, review_directory_path)
end

local function open_review_branch_and_checkout(branch_local_name)
    local curr_dir_full_path = vim.fn.getcwd()
    local review_directory_name = get_review_directory_name(curr_dir_full_path)
    local review_directory_path = get_relative_review_directory_path(
                                      review_directory_name)
    if branch_local_name then
        local git_worktree_command = string.format("git worktree add -f %s %s",
                                                   review_directory_path,
                                                   branch_local_name)
        git_worktree_remove_command(review_directory_path)
        vim.fn.system(git_worktree_command)
    end
    -- terminal will be in a bad state if we don't delete the project terminal
    delete_project_terminal_if_exists(review_directory_name)
    local tcd_path = get_absolute_review_directory_path(curr_dir_full_path,
                                                        review_directory_path)
    vim.cmd("tabnew")
    vim.cmd(string.format("tcd %s", tcd_path))
end

function M.open_review_branch() open_review_branch_and_checkout(nil) end

function M.delete_review_branch()
    local curr_dir_full_path = vim.fn.getcwd()
    local review_directory_name = get_review_directory_name(curr_dir_full_path)
    local review_directory_path = get_relative_review_directory_path(
                                      review_directory_name)
    git_worktree_remove_command(review_directory_path)
    delete_project_terminal_if_exists(review_directory_name)
end

function M.setup_review_branch()
    -- Get git branches that includes origin remote, sorted by earliest
    local results = vim.fn.systemlist(
                        "git --no-pager branch -lr --sort=-committerdate")

    vim.ui.select(results, {prompt = "Select Branch: "}, function(choice)
        if not choice then return end
        local branch_local_name = choice:gsub("^[%s]*origin/", "")
        open_review_branch_and_checkout(branch_local_name)
    end)
end

function M.open_workspace_tab()
    -- Get git branches that includes origin remote, sorted by earliest
    local results = vim.g.workspace_directories or {}

    vim.ui.select(results, {prompt = "Select Workspace Directory: "},
                  function(choice)
        if not choice then return end
        vim.cmd("tabnew")
        vim.cmd("tcd " .. choice)
    end)
end

function M.close_and_reopen_nvim()
    local session_file = vim.fn.stdpath("data") .. "/restart_session.vim"

    -- Save current session (buffers, tabs, layout)
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))

    vim.fn.writefile({string.format("-S %s", session_file)},
                     string.format("%s/.nvim-restart.flag", os.getenv("HOME")))
    vim.cmd("qa!")
end

function M.set_print_snippet(kwargs)
    local is_json = kwargs.is_json
    local format = kwargs.format
    local buffer = kwargs.buffer

    for _, is_visual in pairs({true, false}) do
        local delete_op = is_visual and "c" or "o"
        local keymap_mode = is_visual and "v" or "n"
        local keymap = is_json and "<leader>sjp" or "<leader>sp"
        local func_id = uuid()
        local remap_func_tab = vim.g.print_remap_func
        remap_func_tab[func_id] = function()
            local copyVal = vim.fn.getreg('"')
            local formattedInsert = interp(format, {copy = copyVal})
            vim.fn.setreg("x", formattedInsert)
        end
        vim.g.print_remap_func = remap_func_tab
        local remap_str = string.format(
                              "%s<cmd>lua vim.g.print_remap_func['%s']()<CR><C-r>x<ESC>",
                              delete_op, func_id)
        local opts = {}
        if buffer then opts.buffer = buffer end
        vim.keymap.set(keymap_mode, keymap, remap_str, opts)
    end

end

function M.cancel_debug_buffer()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    debugOutputMap[debugFile] = nil
    vim.api.nvim_del_augroup_by_name("DebugBuffer")
    vim.print("Debug buffer cleared")
end

local function run_external_command_and_print_output(command, debugFile)
    local debugOutBuf = debugOutputMap[debugFile]
    if not debugOutBuf then error("debugOutBuf cannot be nil") end
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
        end
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
        group = vim.api.nvim_create_augroup("DebugBuffer", {clear = true}),
        pattern = debugFilePattern,
        callback = function()
            local debugFileType = vim.fn.expand("%:e")
            local commandFunc = debugFileTypeToCommand[debugFileType]
            if commandFunc == nil then return end
            local command = commandFunc(debugFile)
            run_external_command_and_print_output(command, debugFile)
        end
    })
end

function M.run_command_in_debug_terminal()
    local debugFile = vim.fn.expand("%:p") -- full path from root
    local debugFileType = vim.fn.expand("%:e")
    local commandFunc = debugFileTypeToCommand[debugFileType]
    if commandFunc == nil then return end

    -- If we had a regular debug buffer, then we remove it
    local debugOutBuf = debugOutputMap[debugFile]
    if debugOutBuf then M.cancel_debug_buffer() end

    -- enter debug terminal whether old or new
    terminal_functions.open_debug_terminal_for_current_file()
    local command = commandFunc(debugFile)
    for _, cmd in ipairs(command) do
        vim.api.nvim_feedkeys(cmd .. " ", "n", true)
    end
    send_keys("<CR>")
end

M.open_terminal = terminal_functions.open_terminal
M.open_debug_terminal_for_current_file =
    terminal_functions.open_debug_terminal_for_current_file
M.open_project_terminal = terminal_functions.open_project_terminal
M.send_visual_selection_to_last_opened_terminal =
    terminal_functions.send_visual_selection_to_last_opened_terminal

return M
