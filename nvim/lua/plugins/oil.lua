local function setup_oil()
    require("oil").setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you still want to use netrw.
      default_file_explorer = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      }
    })

    vim.keymap.set('n', '<leader>fs', '<cmd>lefta vnew<CR><cmd>e .<CR>', { noremap = true })
    vim.keymap.set('n', '<leader>fa', '<cmd>call setreg("n", expand("%:h"))<CR><cmd>lefta vnew<CR><cmd>exe "e" getreg("n")<CR>', { noremap = true, silent = true })
end

return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = setup_oil
}
