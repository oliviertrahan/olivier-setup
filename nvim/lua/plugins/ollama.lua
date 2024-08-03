return {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	-- All the user commands added by the plugin
	-- cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

	config = function()
        local ollama_model = os.getenv("OLLAMA_MODEL")
        if not ollama_model then
            return
        end
		vim.keymap.set({ "n", "v" }, "<leader>co", ":<c-u>lua require('ollama').prompt()<cr>")
		vim.keymap.set({ "n", "v" }, "<leader>cg", ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>")

		local ollama = require("ollama")
       	local opts = {
          model = ollama_model,
          url = "http://127.0.0.1:11434",
          serve = {
            on_start = false,
            command = "ollama",
            args = { "serve" },
            stop_command = "pkill",
            stop_args = { "-SIGTERM", "ollama" },
          },
          -- View the actual default prompts in ./lua/ollama/prompts.lua
          prompts = {
            Sample_Prompt = {
              prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
              input_label = "> ",
              model = "mistral",
              action = "display",
            }
          }
      	}
		ollama.setup(opts)
	end,
}
