return {
  "mistricky/codesnap.nvim",
  build = function()
      if is_windows() then
          return
      end
      return "make"
  end,
  opts = {
    save_path = "~/CodeSnap",
    has_breadcrumbs = true,
    bg_theme = "grape",
  },
  enabled = function() 
      return not is_windows() 
  end,
}
