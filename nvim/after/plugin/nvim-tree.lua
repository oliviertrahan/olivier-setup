vim.g.loaded_netrw = 1
vim.g.loaded_netrw_plugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  view = {
    width = 30
  },
  renderer = {
    group_empty = true
  },
  filters = {
    dotfiles = true
  }
})

vim.keymap.set("n", "<leader>go", "<cmd>NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>gf", "<cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>gt", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>gc", "<cmd>NvimTreeCollapse<CR>")

local function auto_update_path()
  local buf = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(buf)
  if vim.fn.isdirectory(bufname) or vim.fn.isfile(bufname) then
    require("nvim-tree.api").tree.find_file(vim.fn.expand("%:p"))
  end
end

-- Change working directory of current buffer to nvim-tree
vim.api.nvim_create_autocmd("VimEnter,BufEnter", { callback = auto_update_path })
-- vim.api.nvim_create_autocmd("VimEnter", { callback = vim.cmd.NvimTreeFocus })
