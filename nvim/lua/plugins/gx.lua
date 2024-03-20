 return {
    "chrishrb/gx.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = function()
    	require("gx").setup()
        vim.keymap.set({'n', 'v'}, 'gx', '<cmd>Browse<CR>', { noremap = true, silent = true })
    end,
  }

