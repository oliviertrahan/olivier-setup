function dap_config()
    local dap = require('dap')
    local dapui = require("dapui")
    
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dc", dap.continue)
    vim.keymap.set("n", "<leader>dso", dap.step_over)
    vim.keymap.set("n", "<leader>dgo", dap.step_out)
    vim.keymap.set("n", "<leader>di", dap.step_into)
    vim.keymap.set("n", "<leader>dro", dap.repl.open)
    vim.keymap.set("n", "<leader>duc", dapui.close)

    vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
        require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
        require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)

    dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' }
    }

    vim.g.select_dotnet_project = function()
        if csharp_project_configs == nil then
            vim.print("No project configs found")
            return
        end
        vim.cmd(string.format('set cmdheight=%s', #csharp_project_configs + 2))
        local project_choices = ""
        for idx, config in pairs(csharp_project_configs) do
            project_choices = project_choices .. string.format("%s: %s - %s\n", idx, config.name, config.path)
        end
        local selection = vim.fn.confirm('Select the project:\n', project_choices, #csharp_project_configs)
        vim.cmd('set cmdheight=1')
        if (selection > #csharp_project_configs) then
            vim.print("Invalid selection\n")
            return
        end
        return selection
    end

    vim.g.dotnet_build_project = function(selection)
        local project_config = csharp_project_configs[selection]
        local cmd = 'dotnet build -c Debug ' .. project_config.build_path
        print('')
        print('Cmd to execute: ' .. cmd)
        local f = os.execute(cmd)
        if f == 0 then
            print('\nBuild: ✔️ ')
        else
            print('\nBuild: ❌ (code: ' .. f .. ')')
        end
    end

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = "RVezy.Api.dll",
            args = {},
            -- cwd = "/Users/oliviertrahan/workspace/rvezy-back-end/RVezy.Api/bin/Debug/net8.0",
            stopAtEntry = true
            -- env = {
            --     ASPNETCORE_ENVIRONMENT = "Development",
            --     ASPNETCORE_URLS = "http://localhost:5000"
            -- }
            -- program = function()
            --     local selection = vim.g.select_dotnet_project()
            --     if selection == nil then
            --         return
            --     end
            --     local project_config = csharp_project_configs[selection]
            --     if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
            --         vim.g.dotnet_build_project(selection)
            --     end
            --     vim.print("project_config.path: " .. project_config.path)
            --     return project_config.path
            -- end
        }
    }

    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
            -- Example:
            -- stacks = {
            --   open = "<CR>",
            --   expand = "o",
            -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
            {
                elements = {
                    -- Elements can be strings or table with id and size keys.
                    { id = "scopes", size = 0.25 },
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40, -- 40 columns
                position = "left",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
            },
        },
        controls = {
            -- Requires Neovim nightly (or 0.8 when released)
            enabled = true,
            -- Display controls in this element
            element = "repl",
            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "↻",
                terminate = "□",
            },
        },
        floating = {
            max_height = nil,  -- These can be integers or a float between 0 and 1.
            max_width = nil,   -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
        render = {
            max_type_length = nil, -- Can be integer or nil.
            max_value_lines = 100, -- Can be integer or nil.
        }
    })


    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end
    
return {
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
           'mfussenegger/nvim-dap'
        },
    	config = dap_config
    }
}

