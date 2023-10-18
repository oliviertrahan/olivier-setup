vim.g.loaded_netrw = 1
vim.g.loaded_netrw_plugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
end

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  update_focused_file = {
      enable = true
  },
  view = {
    width = 30
  },
  renderer = {
    group_empty = true
  },
  filters = {
    dotfiles = true
  },
  on_attach = my_on_attach
})

vim.keymap.set("n", "<leader>go", "<cmd>NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>gf", "<cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>gt", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>gc", "<cmd>NvimTreeCollapse<CR>")

-- local function auto_update_path()
--   local buf = vim.api.nvim_get_current_buf()
--   local bufname = vim.api.nvim_buf_get_name(buf)
--   if vim.fn.isdirectory(bufname) or vim.fn.isfile(bufname) then
--     require("nvim-tree.api").tree.find_file(vim.fn.expand("%:p"))
--   end
-- end

-- Change working directory of current buffer to nvim-tree
-- vim.api.nvim_create_autocmd("VimEnter,BufEnter", { callback = auto_update_path })
-- vim.api.nvim_create_autocmd("VimEnter", { callback = vim.cmd.NvimTreeFocus })
