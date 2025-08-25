return {
  "mistricky/codesnap.nvim",
  build = "make",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  event = "VeryLazy",
  config = function()
      if is_windows() then
          return
      end
      
      local codesnap = require('codesnap')
      codesnap.setup{
        save_path = "~/CodeSnap",
        has_breadcrumbs = true,
        bg_theme = "grape",
      }

  end
}
