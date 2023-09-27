
vim.g.mapleader = " "

-- create new line without going into insert mode
vim.keymap.set("n", "<leader>O", "O<ESC>", { noremap = true })
vim.keymap.set("n", "<leader>o", "o<ESC>", { noremap = true })

--better normal experience
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })
-- vim.keymap.set("n", "J", "11jzz", { noremap = true })
-- vim.keymap.set("n", "K", "11kzz", { noremap = true })
vim.keymap.set("n", "H", "Hzz", { noremap = true })
vim.keymap.set("n", "L", "Lzz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "yA", "mzggVGy`z") -- yank the whole document
vim.keymap.set("n", "Q", "@q")

-- better visual experience
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "x", "<Esc>", { noremap = true })
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true })
vim.keymap.set("v", "A", "mzggoG", { noremap = true }) -- visual select everything

-- better insert experience
vim.keymap.set("i", "<C-l>", "<C-o>l", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>k", { noremap = true })
vim.keymap.set("i", "<C-j>", "<C-o>j", { noremap = true })
vim.keymap.set("i", "<C-i>", "<C-o>diw", { noremap = true })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-r>", "<C-o>R", { noremap = true }) --change from  insert mode to replace mode
vim.keymap.set("i", "<C-a>", "<C-o>i", { noremap = true }) --change from replace mode to insert mode
vim.keymap.set("i", "jj", "<Esc>")

-- better window management
vim.keymap.set("n", "<leader>wo", "<cmd>rightb vnew<CR><C-w>l")
vim.keymap.set("n", "<leader>ws", "<cmd>rightb new<CR><C-w>j")
vim.keymap.set("n", "<leader>wt", "<cmd>split<CR><C-w>j<cmd>terminal<CR>")
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

--Terminal mode improvement
-- vim.keymap.set("t", "jj", "<C-\\><C-n>")
-- vim.keymap.set("t", "pp", "<C-\\><C-O>p")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

