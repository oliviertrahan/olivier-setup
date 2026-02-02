-- the file has extra remaps that are neovim specific
-- common remaps are at common_remaps.vim
local remap_funcs = require("setup.remap_functions")
-- Setup custom commands
vim.api.nvim_create_user_command("SetupReviewBranch",
                                 remap_funcs.setup_review_branch, {})
vim.api.nvim_create_user_command("OpenReviewBranch",
                                 remap_funcs.open_review_branch, {})
vim.api.nvim_create_user_command("DeleteTabCwd", remap_funcs.delete_tab_cwd, {})
vim.api.nvim_create_user_command("MacroEdit", remap_funcs.macro_edit, {})
vim.api.nvim_create_user_command("MacroPaste", remap_funcs.macro_paste, {})
vim.api.nvim_create_user_command("MacroUpdate", remap_funcs.macro_update, {})

-- remap functions
local open_msys_bash_here = remap_funcs.open_msys_bash_here
local open_project_terminal = remap_funcs.open_project_terminal
local open_debug_terminal_for_current_file =
    remap_funcs.open_debug_terminal_for_current_file
local open_terminal = remap_funcs.open_terminal
local create_debug_buffer = remap_funcs.create_debug_buffer
local cancel_debug_buffer = remap_funcs.cancel_debug_buffer
local macro_edit = remap_funcs.macro_edit
local macro_paste = remap_funcs.macro_paste
local macro_update = remap_funcs.macro_update
local replace_visual_selection_macro_to_term_codes =
    remap_funcs.replace_visual_selection_macro_to_term_codes
local open_workspace_tab = remap_funcs.open_workspace_tab

local replace_visual_selection_term_codes_to_macro =
    remap_funcs.replace_visual_selection_term_codes_to_macro
local run_command_in_debug_terminal = remap_funcs.run_command_in_debug_terminal
local send_visual_selection_to_last_opened_terminal =
    remap_funcs.send_visual_selection_to_last_opened_terminal
local send_clipboard_to_last_opened_terminal =
    remap_funcs.send_clipboard_to_last_opened_terminal
local wrap_with_function_name = remap_funcs.wrap_with_function_name
local run_selection_in_debug_buffer = remap_funcs.run_selection_in_debug_buffer
local wk = require("which-key")

local cleanup_if_oil_path = function(path)
    if path:match("^oil://") then path = path:sub(7) end
    return path
end

local copy_file_path_relative = function()
    local path = vim.fn.expand("%")
    path = cleanup_if_oil_path(path)

    -- Only modify path if on Windows, for git bash
    if is_windows() then
        -- Convert Windows-style backslashes to forward slashes
        path = path:gsub("\\", "/")
        -- Convert drive letter (e.g., C:/) to /c/
        path = path:gsub("^([A-Za-z]):",
                         function(drive) return "/" .. drive:lower() end)
    end

    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end

vim.keymap.set("n", "<leader>pp", copy_file_path_relative,
               {desc = "Copy file path relative to cwd"})
vim.api.nvim_create_user_command("CopyFilePathRelative",
                                 copy_file_path_relative, {})

-- overrides the <Space>fo mapping from common_remaps.vim
vim.keymap.set("n", "<leader>fo", function()
    local directory_of_current_file = vim.fn.expand("%:p:h")
    directory_of_current_file =
        cleanup_if_oil_path(directory_of_current_file)
    -- We assume windows or macOS for now
    local open_cmd_command = is_windows() and "explorer" or "open"
    vim.cmd(string.format("!%s %s", open_cmd_command,
                          directory_of_current_file))
end, { desc = "Open current file directory (macOS or windows only)" })

-- better yanking experience
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local remap_group = augroup("RemapGroup", {})

vim.keymap.set("n", "y", "mpy", {noremap = true}) -- set mark before yanking
vim.keymap.set("n", "Y", "mpv$hy", {noremap = true}) -- set mark before yanking
-- Highlight yanked text
autocmd("TextYankPost", {
    group = remap_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({higroup = "IncSearch", timeout = 40})
        local ev = vim.v.event
        if ev.operator == "y" and not ev.visual then
            vim.cmd("normal! `p") -- go back to mark after yanking
        end
    end
})

-- Close all unnamed buffers on exit
autocmd("ExitPre", {
    group = remap_group,
    pattern = "*",
    callback = function()
        -- Iterate over all buffers. If buffer is valid and has no name, delete it so that we can save and quit
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(bufnr) then
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname == "" then
                    vim.api.nvim_buf_delete(bufnr, {force = true})
                end
            end
        end

    end
})

-- miscellaenous
vim.keymap.set("v", "<leader>S", wrap_with_function_name)

-- macro
wk.register({ 
    { "<leader>m", group = "macro" }
})
vim.keymap.set("n", "<leader>me", macro_edit, {desc = "Edit Macro"})
vim.keymap.set("n", "<leader>mp", macro_paste, {desc = "Paste Macro"})
vim.keymap.set("v", "<leader>mu", macro_update, {desc = "Update Macro"})

vim.keymap.set("v", "<leader>rt", replace_visual_selection_macro_to_term_codes)
vim.keymap.set("v", "<leader>rm", replace_visual_selection_term_codes_to_macro)

-- Register which-key mappings for LSP
wk.register({
    { "<leader>cl", group = "lsp" }
})
vim.keymap.set("n", "<leader>clr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" }) -- embarassing to have to restart the lsp so often that i want a mapping
vim.keymap.set("n", "<leader>cli", "<cmd>LspInfo<cr>", { desc = "LSP Info" })

-- debugging buffers
vim.keymap.set("v", "<leader>ddp", run_selection_in_debug_buffer, { desc = "Run visual selection in debug buffer" })
vim.keymap.set("n", "<leader>ddo", create_debug_buffer, { desc = "Create debug buffer" })
vim.keymap.set("n", "<leader>ddc", cancel_debug_buffer, { desc = "Cancel debug buffer" })
vim.keymap.set("n", "<leader>dtt", run_command_in_debug_terminal, { desc = "Run command in debug terminal" })
vim.keymap.set("n", "<leader>dts", open_debug_terminal_for_current_file, { desc = "Open debug terminal for current file" })

-- quickfix list
vim.keymap.set("n", "<leader>qj", "<cmd>cnext<CR>", { desc = "Next entry in quickfix list" })
vim.keymap.set("n", "<leader>qk", "<cmd>cnext<CR>", { desc = "Previous entry in quickfix list" })
vim.keymap.set("n", "<leader>qh", "<cmd>colder<CR>", { desc = "Previous quickfix list" })
vim.keymap.set("n", "<leader>ql", "<cmd>cnewer<CR>", { desc = "Next quickfix list" })
vim.keymap.set("n", "<leader>two", open_workspace_tab, { desc = "Open workspace tab" })

-- Terminal mode improvement
autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term-open', {clear = true}),
    pattern = '*',
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end
})

vim.keymap.set("n", "<leader>tt", open_msys_bash_here)
vim.keymap.set("v", "<leader>st", send_visual_selection_to_last_opened_terminal)
vim.keymap.set("n", "<leader>st", send_clipboard_to_last_opened_terminal)

vim.keymap.set("n", "<C-t>", open_project_terminal)
vim.keymap.set("v", "<C-t>", open_project_terminal)

vim.keymap.set("t", "<C-t>", "<C-\\><C-n><C-w>c", { desc = "Close terminal window" })
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>", { desc = "Switch to normal mode" })
vim.keymap.set("t", "<C-p>", "<C-\\><C-o>p", { desc = "Paste in terminal mode" })
vim.keymap.set("t", "<C-v>", '<C-\\><C-o>"+P', { desc = "Paste from system clipboard in terminal mode" })
vim.keymap.set("t", "<C-o>", "<C-\\><C-o>", { desc = "Execute one normal mode command in terminal" })

-- better terminal management
-- Register terminal mappings with which-key
vim.keymap.set("n", "<leader>t1", function() open_terminal(1) end, { desc = "Open terminal 1" })
vim.keymap.set("n", "<leader>t2", function() open_terminal(2) end, { desc = "Open terminal 2" })
vim.keymap.set("n", "<leader>t3", function() open_terminal(3) end, { desc = "Open terminal 3" })
vim.keymap.set("n", "<leader>t4", function() open_terminal(4) end, { desc = "Open terminal 4" })
vim.keymap.set("n", "<leader>t5", function() open_terminal(5) end, { desc = "Open terminal 5" })

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)
