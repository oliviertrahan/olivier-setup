return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        mappings_version_prompt = false
    },
    keys = {
        {
            "<leader>?",
            function() require("which-key").show({global = false}) end,
            desc = "Buffer Local Keymaps (which-key)"
        }
    }
}
