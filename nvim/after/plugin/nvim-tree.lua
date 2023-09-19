vim.g.loaded_netrw = 1
vim.g.loaded_netrw_plugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set("n", "<leader>to", "<cmd>NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>tc", "<cmd>NvimTreeCollapse<CR>")
