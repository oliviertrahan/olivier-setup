-- Load the workspace directories
local success = pcall(function()
    return require("not_pushed.workspace_directories")
end)
if not success then vim.g.workspace_directories = {} end
vim.g.tab_names = {}

-- close and reopen nvim, 
-- put close to top so if any other sourcing fails,
-- we can still restart easy
function close_and_reopen_nvim()
    local session_file = vim.fn.stdpath("data") .. "/restart_session.vim"

    -- Save current session (buffers, tabs, layout)
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))

    vim.fn.writefile({string.format("-S %s", session_file)},
                     string.format("%s/.nvim-restart.flag", os.getenv("HOME")))
    vim.cmd("qa!")
end

vim.keymap.set("n", "ZR", close_and_reopen_nvim,
               {desc = "close and reopen nvim with current files"}) -- close and reopen nvim with same workspace and current file opened

-- Cleanup leftover shada temp files on startup
local shada_dir = vim.fn.stdpath("data") .. "/shada"
for _, f in ipairs(vim.fn.glob(shada_dir .. "/main.shada.tmp.*", 1, 1)) do
    vim.fn.delete(f)
end

require("setup.lua_extensions")
vim.cmd(resolve_path(string.format("source %s", "$HOME/.commonvimrc")))

require("setup.lazy")
require("setup.set")
require("setup.remap")
require("setup.snippets")
require("setup.print_snippets")
require("setup.buf_write_pre")
require("setup.buf_read_pre")
local autocmd = vim.api.nvim_create_autocmd

function R(name) require("plenary.reload").reload_module(name) end

-- When we leave terminal mode or when we refocus neovim, then check files for changes
autocmd({"FocusGained", "TermLeave"},
        {pattern = "*", callback = function() vim.cmd("checktime") end})

--Adding script for a work setup
vim.api.nvim_create_user_command("WorkStart", function()
  pcall(require, "not_pushed.work_startup")
end, {})

--Adding script for a personal setup
vim.api.nvim_create_user_command("PersonalStart", function()
  pcall(require, "not_pushed.personal_startup")
end, {})
