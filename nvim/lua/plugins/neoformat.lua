---@diagnostic disable: undefined-global
local success, neoformat_config = pcall(function() return require('not_pushed.neoformat_config') end)
if not success then
    return {}
end

local function addFileTypeToDict(dict, fileType, config)
    local configs = dict[fileType]
    if (configs == nil) then
        configs = {}
        dict[fileType] = configs
    end
    table.insert(configs, config)
end

local fileTypesToConfigs = {}
for _, formatter_config in ipairs(neoformat_config) do
    for _, fileType in ipairs(formatter_config.filetypes) do
        addFileTypeToDict(fileTypesToConfigs, fileType, formatter_config)
    end
end

local allValidFileTypes = {}
for fileType, _  in pairs(fileTypesToConfigs) do
    table.insert(allValidFileTypes, "*." .. fileType)
end

local function formatCallback()
    local fileType = vim.fn.expand("<afile>:e")
    local configsForFileType = fileTypesToConfigs[fileType]
    if not configsForFileType then
        return
    end
    for _, config in ipairs(configsForFileType) do
        local configPath = vim.fn.expand(config.dir_path)
    	local fullPath = vim.fn.expand("<afile>:p")
        if string.find(fullPath, configPath, 1, true) then
            local command = "Neoformat " .. config.neoformat_command
            vim.print("command: " .. command)
            vim.cmd(command)
            return
        end
    end
end

return {
    'sbdchd/neoformat',
    name = 'neoformat',
    config = function()
        vim.g.neoformat_try_node_exe = 1

        vim.api.nvim_create_autocmd(
            { 'BufWritePre' },
            {
                pattern = allValidFileTypes,
                callback = formatCallback
            }
        )
    end
}
