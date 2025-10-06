-- https://github.com/LukasPietzschmann/telescope-tabs
-- https://github.com/nvim-telescope/telescope.nvim
-- https://github.com/nvim-telescope/telescope-file-browser.nvim
local function setup_telescope()
    if vim.g.started_by_firenvim then return end
    ---@diagnostic disable: undefined-global
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local selections_to_skip = 10
    local scroll_many_results_previous =
        function(prompt_bufnr)
            for _ = 1, selections_to_skip, 1 do
                actions.move_selection_previous(prompt_bufnr)
            end
        end
    local scroll_many_results_next = function(prompt_bufnr)
        for _ = 1, selections_to_skip, 1 do
            actions.move_selection_next(prompt_bufnr)
        end
    end

    telescope.setup({
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-c>"] = actions.close
                },
                n = {
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["H"] = scroll_many_results_previous,
                    ["L"] = scroll_many_results_next,
                    ["<C-c>"] = actions.close
                }
            }
        },
        pickers = {
            find_files = {hidden = true},
            buffers = {
                mappings = {
                    i = {["<C-d>"] = actions.delete_buffer},
                    n = {["<C-d>"] = actions.delete_buffer}
                }
            }
        }
    })
    telescope.load_extension("telescope-tabs")
    local tab_display = function(tab_id, _, _, _, is_current)
        local tab_name = vim.g.tab_names[tostring(tab_id)] or ""
        local current_str = is_current and "<" or ""
        local tab_str =
            string.format("%s: %s %s", tab_id, tab_name, current_str)
        return tostring(tab_str)
    end
    require("telescope-tabs").setup({
        entry_formatter = tab_display,
        entry_ordinal = tab_display
    })

    local builtin = require("telescope.builtin")
    local find_standard_params = {
        "rg", "--files", "--hidden", "--smart-case", "-g", "!.git"
    }
    local find_include_gitignore_params = {
        "rg", "--files", "--hidden", "-u", "--smart-case", "-g", "!.git"
    }

    local find_standard = function()
        builtin.find_files({find_command = find_standard_params})
    end
    local find_standard_on_path = function()
        local path = vim.fn.input("Directory path to search from: ")
        builtin.find_files({find_command = find_standard_params, cwd = path})
    end
    local find_include_gitignore = function()
        builtin.find_files({find_command = find_include_gitignore_params})
    end

    local wk = require("which-key")

    -- normal mode mappings:
    wk.register({
        f = {
            name = "+file/telescope",
            e = {builtin.resume, "Resume last search"},
            t = {
                '<cmd>lua require("telescope-tabs").list_tabs()<CR>',
                "List Tabs"
            },
            f = {find_standard, "Find files (standard)"},
            p = {find_standard_on_path, "Find files on path"},
            b = {builtin.buffers, "Buffers"},
            r = {
                "<cmd>Telescope oldfiles only_cwd=true<CR><C-c>",
                "Recent Files (cwd)"
            },
            cc = {builtin.commands, "Commands"},
            d = {builtin.help_tags, "Help tags"},
            g = {builtin.live_grep, "Live grep"},
            cg = {
                "<cmd>Telescope current_buffer_fuzzy_find<CR>",
                "Fuzzy Find (buffer)"
            },
            l = {
                name = "find (lazy data)",
                f = {
                    function()
                        builtin.find_files {
                            cwd = vim.fs
                                .joinpath(vim.fn.stdpath("data"), "lazy")
                        }
                    end, "Find files (lazy dir)"
                },
                g = {
                    function()
                        builtin.live_grep {
                            cwd = vim.fs
                                .joinpath(vim.fn.stdpath("data"), "lazy")
                        }
                    end, "Live grep (lazy dir)"
                }
            },
            w = {
                name = "workspace",
                f = {
                    function()
                        builtin.find_files({
                            find_command = find_standard_params,
                            search_dirs = get_working_directories()
                        })
                    end, "Find files (workspace)"
                },
                g = {
                    function()
                        builtin.live_grep({
                            search_dirs = get_working_directories()
                        })
                    end, "Live grep (workspace)"
                }
            },
            h = {
                name = "Hidden (gitignored, other repo specific ignores)",
                f = {find_include_gitignore, "Find (with .gitignore)"},
                g = {
                    function()
                        builtin.live_grep {
                            additional_args = function(_)
                                return {"--hidden"}
                            end
                        }
                    end, "Live grep (hidden)"
                },
                w = {
                    name = "workspace (hidden)",
                    f = {
                        function()
                            builtin.find_files({
                                find_command = find_include_gitignore_params,
                                search_dirs = get_working_directories()
                            })
                        end, "Find files (workspace, .gitignore)"
                    },
                    g = {
                        function()
                            builtin.live_grep {
                                search_dirs = get_working_directories(),
                                additional_args = function(_)
                                    return {"--hidden"}
                                end
                            }
                        end, "Live grep workspace (hidden)"
                    }
                }
            }
        }
    }, {prefix = "<leader>"})

    -- Visual mode mappings:
    wk.register({
        f = {
            d = {
                'y<cmd>Telescope help_tags<CR><C-r>"<C-c>',
                "Help tags (selection)"
            },
            g = {
                function()
                    vim.cmd("norm! y")
                    builtin.grep_string({search = vim.fn.getreg('"')})
                    send_keys("<C-c>")
                end, "Grep string (selection)"
            },
            hg = {
                function()
                    vim.cmd("norm! y")
                    builtin.grep_string {
                        search = vim.fn.getreg('"'),
                        additional_args = function(_)
                            return {"--hidden"}
                        end
                    }
                    send_keys("<C-c>")
                end, "Grep string (hidden, selection)"
            },
            cg = {
                'y<cmd>Telescope current_buffer_fuzzy_find<CR><C-r>"<ESC>',
                "Fuzzy buffer (selection)"
            },
            lg = {
                function()
                    vim.cmd("norm! y")
                    builtin.grep_string {
                        search = vim.fn.getreg('"'),
                        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
                    }
                    send_keys("<C-c>")
                end, "Live grep (lazy dir, selection)"
            },
            wg = {
                function()
                    vim.cmd("norm! y")
                    builtin.grep_string({
                        search_dirs = get_working_directories(),
                        search = vim.fn.getreg('"')
                    })
                end, "Live grep (workspace, selection)"
            }
        }
    }, {prefix = "<leader>", mode = "v"})
end

return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = vim.g.started_by_firenvim,
        dependencies = {{"nvim-lua/plenary.nvim"}, {'folke/which-key.nvim'}}
    }, {
        "LukasPietzschmann/telescope-tabs",
        lazy = vim.g.started_by_firenvim,
        dependencies = {{"nvim-telescope/telescope.nvim"}}
    }, {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = vim.g.started_by_firenvim,
        dependencies = {{"nvim-telescope/telescope.nvim"}},
        config = setup_telescope
    }
}
