return {
    "jackMort/ChatGPT.nvim",
  	lazy = vim.g.started_by_firenvim,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function()
        if not os.getenv("OPENAI_API_KEY") then
            return
        end
        require("chatgpt").setup()
        vim.keymap.set("n", "<leader>cc", "<cmd>ChatGPT<CR>")
        vim.keymap.set("v", "<leader>cc", "y<cmd>ChatGPT<CR>p")
        vim.keymap.set({ "n", "v" }, "<leader>ce", "<cmd>ChatGPTEditWithInstructions<CR>")
        vim.keymap.set({ "n", "v" }, "<leader>cr", ":ChatGPTRun ")
        vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>ChatGPTRun translate french<CR>")
    end
}
