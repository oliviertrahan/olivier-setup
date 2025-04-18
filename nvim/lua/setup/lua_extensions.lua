function interp(s, tab)
    return (s:gsub("($%b{})", function(w) return tab[w:sub(3, -2)] or w end))
end

function standardize_url(url)
    if url:sub(-1) ~= "/" then return url .. "/" end
    return url
end

function uuid()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
        return string.format("%x", v)
    end)
end

function dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then k = '"' .. k .. '"' end
            s = s .. "[" .. k .. "] = " .. dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function insertAtCursor(content)
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, pos) .. content .. line:sub(pos + 1)
    vim.api.nvim_set_current_line(nline)
end

---@diagnostic disable-next-line: duplicate-set-field
function shallow_copy(t)
    local t2 = {}
    for k, v in pairs(t) do t2[k] = v end
    return t2
end

function get_active_tabpage_for_buffer(buffer_id)
    for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local windows = vim.api.nvim_tabpage_list_wins(tabpage)
        for _, window in ipairs(windows) do
            local win_buf = vim.api.nvim_win_get_buf(window)
            if win_buf == buffer_id then return tabpage end
        end
    end
    return nil
end

function send_keys(keys_to_send)
    local keys = vim.api.nvim_replace_termcodes(keys_to_send, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end

function merge_tables(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            -- If the target already contains a table at this key, merge the nested tables.
            if type(target[key]) == "table" then
                merge_table(target[key], value)
            else
                -- Otherwise, copy the entire table from source.
                target[key] = value
            end
        else
            -- For non-table values, simply copy the value from source to target.
            target[key] = value
        end
    end
end

function get_visual_selection()
    -- Yank current visual selection into the 'v' register
    -- Note that this makes no effort to preserve this register
    vim.cmd('noau normal! "vy')
    return vim.fn.getreg('v')
end

-- _G.dump = dump

getmetatable("").shallow_copy = shallow_copy
getmetatable("").dump = dump
getmetatable("").standardize_url = standardize_url
getmetatable("").interp = interp
getmetatable("").insertAtCursor = insertAtCursor
getmetatable("").uuid = uuid
getmetatable("").get_active_tabpage_for_buffer = get_active_tabpage_for_buffer
getmetatable("").send_keys = send_keys
getmetatable("").get_visual_selection = get_visual_selection
getmetatable("").merge_tables = merge_tables
