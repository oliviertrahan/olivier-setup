local remap_funcs = require('setup.remap_functions')
local set_print_snippet = remap_funcs.set_print_snippet
local open_project_terminal = remap_funcs.open_project_terminal
local open_terminal = remap_funcs.open_terminal
local create_debug_buffer = remap_funcs.create_debug_buffer

vim.g.mapleader = " "

--better editing experience
vim.keymap.set("n", "J", "miJ`i", { noremap = true })
vim.keymap.set("n", "H", "Hzz", { noremap = true })
vim.keymap.set("n", "L", "Lzz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "yA", "mzgg0VG$y`z")                     -- yank the whole document
vim.keymap.set("n", "=A", "mzgg0VG$=`z")                     -- format the whole document
vim.keymap.set("n", "Q", "@q")                               --Execute "q" macro with Q
vim.keymap.set("x", "Q", ":norm @q<CR>", { noremap = true }) --Execute "q" macro with Q
vim.keymap.set("n", "x", "\"_dl")                            --delete single character doesn't mess with yank register
vim.keymap.set("n", "gb", "<C-6>")                           -- go back to last file
vim.keymap.set("n", "<leader>pp", function()
    local path = vim.fn.expand('%')
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end)

-- function YankWithoutMoving()
--     local save_cursor = vim.api.nvim_win_get_cursor(0)
--     vim.cmd([[normal! `[v`]y]])
--     vim.api.nvim_win_set_cursor(0, save_cursor)
-- end
-- -- Create a mapping for yanking without moving the cursor
-- vim.keymap.set('n', 'y', ':lua YankWithoutMoving()<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ss", "yiw:%s/<C-r>\"//g<Left><Left>") -- go back to last file
vim.keymap.set("v", "<leader>ss", "y:%s/<C-r>\"//g<Left><Left>")   -- go back to last file
vim.keymap.set("n", "<leader>dd", create_debug_buffer)
vim.keymap.set("n", "/", "/\\c") -- Case Insensitive search
vim.keymap.set("n", "?", "?\\c") -- Case Insensitive search
vim.keymap.set("n", "<leader>qh", "<cmd>colder<CR>") -- Previous quickfix list
vim.keymap.set("n", "<leader>ql", "<cmd>cnewer<CR>") -- Next quickfix list 

-- create new line without going into insert mode
vim.keymap.set("n", "<leader>O", "Oi<ESC>\"_dl", { noremap = false })
vim.keymap.set("n", "<leader>o", "oi<ESC>\"_dl", { noremap = false })

-- better visual experience
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true }) -- Move visually selected text one line up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true }) -- Move visually selected text one line down
vim.keymap.set("v", "x", "<Esc>", { noremap = true })            --x to exit visual mode easily
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true })         --yank won't move cursor anymore
vim.keymap.set("v", "A", "mzgg0oG$", { noremap = true })         -- visual select everything
vim.keymap.set("v", "H", "Hzz", { noremap = true })              --move up doc easily
vim.keymap.set("v", "L", "Lzz", { noremap = true })              --move down doc easily
vim.keymap.set("v", ">", ">gv", { noremap = true })              --continue visually selecting after indenting
vim.keymap.set("v", "<", "<gv", { noremap = true })              --continue visually selecting after indenting
vim.keymap.set("v", "Y", "\"+ygv<Esc>", { noremap = true })      --Y to copy to system clipboard
vim.keymap.set("v", "d", "\"0d", { noremap = true })            -- make delete in visual mode go to yank register so I can paste it later
vim.keymap.set("v", "p", "\"0p", { noremap = true })            --pasting over selected text doesn't delete what is in yank buffer
vim.keymap.set("v", "P", "\"+p", { noremap = true })         	--pasting over selected text doesn't delete what is in yank buffer
vim.keymap.set("v", "il", "<Esc>^v$h", { noremap = true })       --visually select whole line but not EOL char
vim.keymap.set("v", "iL", "<Esc>^v$h", { noremap = true })       --visually select whole line but not EOL char

-- better insert experience
vim.keymap.set("i", "<C-h>", "<C-o>h", { noremap = true })
vim.keymap.set("i", "<C-j>", "<C-o>j", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>k", { noremap = true })
vim.keymap.set("i", "<C-l>", "<C-o>a", { noremap = true })
vim.keymap.set("i", "<C-d>", "<C-o>diw", { noremap = true })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "<Tab>", "<C-V><Tab>", { noremap = true })

-- better window management
vim.keymap.set("n", "<leader>wo", "<cmd>vsplit<CR><C-w>l")
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR><C-w>j")
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

-- print snippets in multiple languages

set_print_snippet(true, false, "vim.print(\"", ": \" .. ", ")")
set_print_snippet(false, false, "vim.print(\"", ": \" .. ", ")")
set_print_snippet(true, true, "vim.print(\"", ": \" .. dump(", "))")
set_print_snippet(false, true, "vim.print(\"", ": \" .. dump(", "))")
set_print_snippet(false, true, "vim.print(\"", ": \" .. dump(", "))")

local snippet_group = vim.api.nvim_create_augroup('augroup', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufEnter', {
    group = snippet_group,
    pattern = '*.cs',
    callback = function(ev)
        set_print_snippet(true, false, "Console.WriteLine($\"", ": {", "}\");", ev.buf)
        set_print_snippet(false, false, "Console.WriteLine($\"", ": {", "}\");", ev.buf)
        set_print_snippet(true, true, "Console.WriteLine($\"", ": {JsonConvert.SerializeObject(", ")}\");", ev.buf)
        set_print_snippet(false, true, "Console.WriteLine($\"", ": {JsonConvert.SerializeObject(", ")}\");", ev.buf)
    end,
})

autocmd('BufEnter', {
    group = snippet_group,
    pattern = { '*.js', '*.mjs', '*.cjs', '*.vue' },
    callback = function(ev)
        set_print_snippet(true, false, "console.log(`", ": ${", "}`)", ev.buf)
        set_print_snippet(false, false, "console.log(`", ": ${", "}`)", ev.buf)
        set_print_snippet(true, true, "console.log(`", ": ${JSON.stringify(", ")}`)", ev.buf)
        set_print_snippet(false, true, "console.log(`", ": ${JSON.stringify(", ")}`)", ev.buf)
    end,
})

autocmd('BufEnter', {
    group = snippet_group,
    pattern = { '*.py' },
    callback = function(ev)
        set_print_snippet(true, false, "print(f\"", ": {", "}\")", ev.buf)
        set_print_snippet(false, false, "print(f\"", ": {", "}\")", ev.buf)
        set_print_snippet(true, true, "print(f\"", ": {json.dumps(", ")}\")", ev.buf)
        set_print_snippet(false, true, "print(f\"", ": {json.dumps(", ")}\")", ev.buf)
    end,
})

--Terminal mode improvement
vim.keymap.set("n", "<C-t>", open_project_terminal)
vim.keymap.set("t", "<C-t>", "<C-\\><C-n><C-w>c")
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-p>", "<C-\\><C-o>p")
vim.keymap.set("t", "<C-v>", "<C-\\><C-o>\"+P")
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
