local function floating_single_line_input(prompt, default_text, callback)
    local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
    local width = math.floor(vim.o.columns * 0.5)
    local row = math.floor(vim.o.lines / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local full_text = prompt .. ": " .. default_text
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = 1,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {full_text})
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buftype = "prompt"

    vim.api.nvim_win_set_cursor(win, {1, #prompt + 2})

    -- Confirm input with Enter
    vim.keymap.set("n", "<CR>", function()
        local input_line = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
        local input = input_line:sub(#prompt + 3) -- Extract user input after the prompt

        vim.api.nvim_win_close(win, true)
        if callback then callback(input) end
    end, {buffer = buf})

    -- Cancel input with Escape
    vim.keymap.set("n", "<Esc>",
                   function() vim.api.nvim_win_close(win, true) end,
                   {buffer = buf})

    -- Start in insert mode at the end of the text
    vim.api.nvim_feedkeys("A", "n", false)
end

return {floating_single_line_input = floating_single_line_input}
