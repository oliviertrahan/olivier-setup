function interp(s, tab)
	return (s:gsub("($%b{})", function(w)
		return tab[w:sub(3, -2)] or w
	end))
end

function standardize_url(url)
	if url:sub(-1) ~= "/" then
		return url .. "/"
	end
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
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
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
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

getmetatable("").shallow_copy = shallow_copy
getmetatable("").dump = dump
getmetatable("").standardize_url = standardize_url
getmetatable("").interp = interp
getmetatable("").insertAtCursor = insertAtCursor
getmetatable("").uuid = uuid
