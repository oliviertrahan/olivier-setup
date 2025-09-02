return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    build = function()
      if is_windows() then
          return
      end
      return "make"
    end,
    enabled = function() 
        return not is_windows() 
    end,
    dependencies = {
        "stevearc/dressing.nvim", "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim", --- The below dependencies are optional,
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {insert_mode = true},
                    -- required for Windows users
                    use_absolute_path = true
                }
            }
        }, 
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {file_types = {"markdown", "Avante"}},
            ft = {"markdown", "Avante"}
        }
    },
    config = function()
        if is_windows() then
            return
        end
        local success, avante_config = pcall(function()
            return require("not_pushed.avante_config")
        end)
        if not success then
            -- default to openai if no config is found
            avante_config = {
                provider = "openai",
                auto_suggestions_provider = "openai",
                behaviour = {auto_suggestions = true},
                openai = {model = "o3-mini"}
            }
        end
        local setup = {
            -- default settings
            mappings = {
                sidebar = {
                    apply_all = "A",
                    apply_cursor = "a",
                    switch_windows = "<C-n>", -- Don't use <Tab> so that we can use copilot
                    reverse_switch_windows = "<C-p>"
                }
            }
        }
        -- Merge the default settings with the user settings
        merge_tables(setup, avante_config)
        require("avante").setup(setup)
        -- require("avante").setup()
    end
}
