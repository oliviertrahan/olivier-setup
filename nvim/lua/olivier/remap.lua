
vim.g.mapleader = " "

--better editing experience
vim.keymap.set("n", "J", "miJ`i", { noremap = true })
vim.keymap.set("n", "H", "Hzz", { noremap = true })
vim.keymap.set("n", "L", "Lzz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "yA", "mzgg0VG$y`z") -- yank the whole document
vim.keymap.set("n", "=A", "mzgg0VG$=`z") -- format the whole document
vim.keymap.set("n", "Q", "@q") --Execute "q" macro with Q
vim.keymap.set("n", "x", "\"_dl") --delete single character doesn't mess with yank register
vim.keymap.set("n", "gb", "<C-6>") -- go back to last file
vim.keymap.set("n", "<leader>pp", function()
	local path = vim.fn.expand('%')
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end)

-- create new line without going into insert mode
vim.keymap.set("n", "<leader>O", "Oi<ESC>\"_dl", { noremap = false })
vim.keymap.set("n", "<leader>o", "oi<ESC>\"_dl", { noremap = false })

-- better visual experience
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true }) -- Move visually selected text one line up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true }) -- Move visually selected text one line down
vim.keymap.set("v", "x", "<Esc>", { noremap = true }) --x to exit visual mode easily
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true }) --yank won't move cursor anymore
vim.keymap.set("v", "A", "mzgg0oG$", { noremap = true }) -- visual select everything
vim.keymap.set("v", "H", "Hzz", { noremap = true }) --move up doc easily
vim.keymap.set("v", "L", "Lzz", { noremap = true }) --move down doc easily
vim.keymap.set("v", ">", ">gv", { noremap = true }) --continue visually selecting after indenting
vim.keymap.set("v", "<", "<gv", { noremap = true }) --continue visually selecting after indenting
vim.keymap.set("v", "Y", "\"+ygv<Esc>", { noremap = true }) --Y to copy to system clipboard
vim.keymap.set("v", "p", "\"_dP", { noremap = true }) --pasting over selected text doesn't delete what is in yank buffer
vim.keymap.set("v", "P", "\"_d\"+P", { noremap = true }) --pasting over selected text doesn't delete what is in yank buffer
vim.keymap.set("v", "il", "<Esc>^v$h", { noremap = true }) --visually select whole line but not EOL char
vim.keymap.set("v", "iL", "<Esc>^v$h", { noremap = true }) --visually select whole line but not EOL char

-- better insert experience
vim.keymap.set("i", "<C-h>", "<C-o>h", { noremap = true })
vim.keymap.set("i", "<C-j>", "<C-o>j", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>k", { noremap = true })
vim.keymap.set("i", "<C-l>", "<C-o>a", { noremap = true })
vim.keymap.set("i", "<C-d>", "<C-o>diw", { noremap = true })
vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("i", "<C-i>", "<C-o>i", { noremap = true }) --change from replace mode to insert mode
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "<Tab>", "<C-V><Tab>", { noremap = true })

-- better window management
vim.keymap.set("n", "<leader>wo", "<cmd>vsplit<CR><C-w>l")
vim.keymap.set("n", "<leader>ws", "<cmd>rightb new<CR>")
vim.keymap.set("n", "<leader>wc", "<C-w>c")
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")

--better tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabonly<CR>")
vim.keymap.set("n", "<leader>tl", "<cmd>+tabnext<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>-tabnext<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>+tabnext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>-tabnext<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>+tabmove<CR>")
vim.keymap.set("n", "<leader>tN", "<cmd>-tabmove<CR>")

local projectTermMap = {}
local extraTermMap = {}

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

local function open_terminal(termId)
    if extraTermMap[termId] then
        open_terminal_buffer(extraTermMap[termId])
    else
        local bufId = open_terminal_buffer(nil)
        extraTermMap[termId] = bufId
    end
end

local function open_project_terminal()
    local current_directory = vim.api.nvim_call_function("getcwd", {})
    local current_directory_name = vim.api.nvim_call_function("fnamemodify", {current_directory, ":t"})

    if projectTermMap[current_directory_name] then
        open_terminal_buffer(projectTermMap[current_directory_name])
    else
        local bufId = open_terminal_buffer(nil)
        projectTermMap[current_directory_name] = bufId
    end
end

--Terminal mode improvement
vim.keymap.set("n", "<C-t>", open_project_terminal)
vim.keymap.set("t", "<C-t>", "<C-\\><C-n><C-w>c")
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-o>", "<C-\\><C-o>")

--better terminal management
vim.keymap.set("n", "<leader>t1", function() open_terminal(1) end)
vim.keymap.set("n", "<leader>t2", function() open_terminal(2) end)
vim.keymap.set("n", "<leader>t3", function() open_terminal(3) end)
vim.keymap.set("n", "<leader>t4", function() open_terminal(4) end)
vim.keymap.set("n", "<leader>t5", function() open_terminal(5) end)

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

