local M = {}
function M.standardize_url(url)
    if url:sub(-1) ~= '/' then
        return url .. '/'
    end
    return url
end

return M
