-- vim.opt.guicursor = ""
vim.opt.vb = false

vim.o.fillchars = "eob: "

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.editorconfig = true

if is_windows() then
  local shell
  if vim.fn.executable("pwsh") == 1 then
    shell = "pwsh"
  elseif vim.fn.executable("powershell") == 1 then
    shell = "powershell"
  else
    shell = "cmd.exe" -- last resort
  end

  vim.opt.shell = shell
  vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

