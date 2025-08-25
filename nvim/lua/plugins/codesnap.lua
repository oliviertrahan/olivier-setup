return {
  "mistricky/codesnap.nvim",
  build = "make",
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
