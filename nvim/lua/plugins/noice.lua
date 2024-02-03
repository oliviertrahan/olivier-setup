return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    "nvim-telescope/telescope.nvim"
  },
  config = function ()
    require("noice").setup({
      -- add any config here
    })
    require("telescope").load_extension("noice")
    vim.keymap.set("n", "<leader>no", "<cmd>NoiceDismiss<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>fn", "<cmd>Telescope noice<CR>", { noremap = true, silent = true })
  end
}
