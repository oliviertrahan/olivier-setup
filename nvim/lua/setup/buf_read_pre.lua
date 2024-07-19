---@diagnostic disable: undefined-global
local success, buf_read_pre_config = pcall(function()
	return require("not_pushed.buf_read_pre_config")
end)
if not success then
	return {}
end

local parseConfig = require("setup.config_utils").parseConfig
local config = parseConfig(buf_read_pre_config)

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
	pattern = config.allValidFileTypes,
	callback = config.executeCallback,
})
