local function addFileTypeToDict(dict, fileType, config)
	local configs = dict[fileType]
	if configs == nil then
		configs = {}
		dict[fileType] = configs
	end
	table.insert(configs, config)
end

--Could be string or function
local function executeCommand(command)
	if type(command) == "function" then
		vim.print("command: custom lua function")
		command()
	elseif type(command) == "string" then
		vim.print("command: " .. command)
		vim.cmd(command)
	else
		vim.print("command is not a string or function. aborting.")
	end
end

local parseConfig = function(execution_config)
	local fileTypesToConfigs = {}
	for _, formatter_config in ipairs(execution_config) do
        if #formatter_config.filetypes > 0 then
            for _, fileType in ipairs(formatter_config.filetypes) do
                addFileTypeToDict(fileTypesToConfigs, fileType, formatter_config)
            end
        else
            addFileTypeToDict(fileTypesToConfigs, "*", formatter_config)
        end
	end

	local allValidFileTypes = {}
	for fileType, _ in pairs(fileTypesToConfigs) do
		table.insert(allValidFileTypes, "*." .. fileType)
	end

    if #allValidFileTypes == 0 then
        table.insert(allValidFileTypes, "*")
    end

	local executeCallback = function()
		local fileType = vim.fn.expand("<afile>:e")
		local configsForFileType = fileTypesToConfigs[fileType]
		if not configsForFileType then
            configsForFileType = fileTypesToConfigs["*"]
            if not configsForFileType then
                return
            end
		end
		for _, config in ipairs(configsForFileType) do
			local configPath = vim.fn.expand(config.dir_path)
			local fullPath = vim.fn.expand("<afile>:p")
			if string.find(fullPath, configPath, 1, true) then
				executeCommand(config.command)
				return
			end
		end
	end

	return {
		allValidFileTypes = allValidFileTypes,
		executeCallback = executeCallback,
	}
end

return {
	parseConfig = parseConfig,
}
