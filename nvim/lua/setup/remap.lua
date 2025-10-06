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
require("which-key").register({
    f = {
        o = {
            function()
                local directory_of_current_file = vim.fn.expand("%:p:h")
                directory_of_current_file =
                    cleanup_if_oil_path(directory_of_current_file)
                -- We assume windows or macOS for now
                local open_cmd_command = is_windows() and "explorer" or "open"
                vim.cmd(string.format("!%s %s", open_cmd_command,
                                      directory_of_current_file))
            end, "Open current file directory (macOS or windows only)"
        }
    }
}, {prefix = "<leader>"})

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
    ["<leader>m"] = {
        name = "+macro", -- group name shown in which-key popup
        e = {macro_edit, "Edit Macro"},
        p = {macro_paste, "Paste Macro"},
        u = {macro_update, "Update Macro"}
    }
})

vim.keymap.set("v", "<leader>rt", replace_visual_selection_macro_to_term_codes)
vim.keymap.set("v", "<leader>rm", replace_visual_selection_term_codes_to_macro)

-- lsp
-- Register which-key mappings for LSP
require('which-key').register({
    -- lsp
    ["<leader>cl"] = {
        name = "+lsp",
        r = {"<cmd>LspRestart<cr>", "Restart LSP"},
        i = {"<cmd>LspInfo<cr>", "LSP Info"}
    }
}, {mode = "n"})

wk.register({d = {}}, {prefix = "<leader>"})

wk.register({
    -- debug
    d = {
        name = "+debug",
        d = {
            name = "+buffer", -- group name shown in which-key
            s = {
                run_selection_in_debug_buffer,
                "Run selection in debug buffer",
                mode = "v"
            },
            o = {create_debug_buffer, "Create debug buffer"},
            c = {cancel_debug_buffer, "Cancel debug buffer"}
        },
        t = {
            name = "+terminal",
            t = {run_command_in_debug_terminal, "Run Command in Debug Terminal"},
            s = {
                open_debug_terminal_for_current_file,
                "Open Debug Terminal for Current File"
            }
        }
    },
    -- quicklist
    q = {
        name = "+quickfix",
        j = {"<cmd>cnext<CR>", "Next quickfix entry"},
        k = {"<cmd>cprev<CR>", "Previous quickfix entry"},
        h = {"<cmd>colder<CR>", "Previous quickfix list"},
        l = {"<cmd>cnewer<CR>", "Next quickfix list"}
    }
}, {prefix = "<leader>"})

vim.keymap.set("n", "<leader>two", open_workspace_tab)

-- Terminal mode improvement
autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term-open', {clear = true}),
    pattern = '*',
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end
})

require("which-key").register({
    s = {
        name = "+send",
        t = {
            {
                send_clipboard_to_last_opened_terminal,
                "Send clipboard to terminal",
                mode = "n"
            }, {
                send_visual_selection_to_last_opened_terminal,
                "Send visual selection to terminal",
                mode = "v"
            }
        }
    }
}, {prefix = "<leader>"})
vim.keymap.set("n", "<C-t>", open_project_terminal)
vim.keymap.set("v", "<C-t>", open_project_terminal)

vim.keymap.set("t", "<C-t>", "<C-\\><C-n><C-w>c")
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-p>", "<C-\\><C-o>p")
vim.keymap.set("t", "<C-v>", '<C-\\><C-o>"+P')
vim.keymap.set("t", "<C-o>", "<C-\\><C-o>")

-- better terminal management
-- Register terminal mappings with which-key
require("which-key").register({
    ["<leader>t"] = {
        name = "+terminal",
        ["1"] = {function() open_terminal(1) end, "Open Terminal 1"},
        ["2"] = {function() open_terminal(2) end, "Open Terminal 2"},
        ["3"] = {function() open_terminal(3) end, "Open Terminal 3"},
        ["4"] = {function() open_terminal(4) end, "Open Terminal 4"},
        ["5"] = {function() open_terminal(5) end, "Open Terminal 5"}
    }
}, {mode = "n"})

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)
