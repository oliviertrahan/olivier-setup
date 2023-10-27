
vim.g.mapleader = " "

-- create new line without going into insert mode
vim.keymap.set("n", "<leader>O", "O<ESC>", { noremap = true })
vim.keymap.set("n", "<leader>o", "o<ESC>", { noremap = true })

--better normal experience
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })
vim.keymap.set("n", "H", "Hzz", { noremap = true })
vim.keymap.set("n", "L", "Lzz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "yA", "mzgg0VG$y`z") -- yank the whole document
vim.keymap.set("n", "Q", "@q")

-- better visual experience
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "x", "<Esc>", { noremap = true })
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true })
vim.keymap.set("v", "A", "mzgg0oG$", { noremap = true }) -- visual select everything
vim.keymap.set("v", "H", "Hzz", { noremap = true })
vim.keymap.set("v", "L", "Lzz", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", "Y", "\"+ygv<Esc>", { noremap = true })
vim.keymap.set("v", "p", "\"_dP", { noremap = true }) --pasting over selected text doesn't delete what is in yank buffer
vim.keymap.set("v", "P", "\"_dP", { noremap = true })
vim.keymap.set("v", "il", "<Esc>^v$h", { noremap = true })
vim.keymap.set("v", "iL", "<Esc>^v$h", { noremap = true })

-- better insert experience
vim.keymap.set("i", "<C-h>", "<C-o>h", { noremap = true })
vim.keymap.set("i", "<C-j>", "<C-o>j", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>k", { noremap = true })
vim.keymap.set("i", "<C-l>", "<C-o>a", { noremap = true })
vim.keymap.set("i", "<C-d>", "<C-o>diw", { noremap = true })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-r>", "<C-o>R", { noremap = true }) --change from  insert mode to replace mode
vim.keymap.set("i", "<C-i>", "<C-o>i", { noremap = true }) --change from replace mode to insert mode
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "<Tab>", "<C-V><Tab>", { noremap = true })

-- better window management
vim.keymap.set("n", "<leader>wo", "<cmd>rightb vnew<CR>")
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
vim.keymap.set("n", "<leader>tn", "<cmd>+tabmove<CR>")
vim.keymap.set("n", "<leader>tN", "<cmd>-tabmove<CR>")

local projectTermMap = {}
local extraTermMap = {}

local function open_terminal_buffer(bufId)
    local open_term_buf = function(id)
        -- local window = vim.api.nvim_get_current_win()

        if bufId == nil then
            vim.cmd("terminal")
        else
            vim.cmd("b " .. id)
        end

        -- change to terminal buffer
        -- vim.api.nvim_set_current_win(window)
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

