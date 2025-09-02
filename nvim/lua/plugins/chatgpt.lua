return {
    "jackMort/ChatGPT.nvim",
  	lazy = vim.g.started_by_firenvim,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    enabled = function()
        return os.getenv("OPENAI_API_KEY")
    end,
    config = function()
        require("chatgpt").setup({
            openai_params = {
                model = "gpt-4-turbo",
            },
        })
        vim.keymap.set("n", "<leader>cc", "<cmd>ChatGPT<CR>")
        vim.keymap.set("v", "<leader>cc", "y<cmd>ChatGPT<CR>p")
        vim.keymap.set({ "n", "v" }, "<leader>ce", "<cmd>ChatGPTEditWithInstructions<CR>")
        vim.keymap.set({ "n", "v" }, "<leader>cr", ":ChatGPTRun ")
        vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>ChatGPTRun translate french<CR>")
    end
}
