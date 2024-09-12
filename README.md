# olivier-setup

All my personal configs

## zsh and symlink env setup

### Running the script and setup

Run `$ source env-setup.sh` to setup your mac/linux box ready for local dev

- the `.zshrc` is the base provided which is universal to my personal config
- the `nvim` folder gets symlinked to the nvim config folder
- an `extra_zshrc.zsh` file may be placed at the project root for secret values that we don't want pushed to the repo (it is added to .gitignore)
- an `extra-setup.zsh` script may be placed at the project root for a secret script that we don't want pushed to the repo. This is ran at the end of the `env-setup.zsh` script

Note: Run `$ source env-setup.zsh -l` to only run symlink updates

### Adding to the script - cd hooks

your extra_zshrc.zsh may contain have to contain directory hooks to change git config based on working project example config used below.

```
sshConfigUsed=

setupgitwork() {
    if [ $# -eq 1 ]; then
        echo "Setting up global git config"
        git config --global user.name <work-username>
        git config --global user.email <work-email>
    else 
        echo "Setting up local git config"
        git config user.name <work-username>
        git config user.email <work-email>
    fi
}

switchsshpersonal() {
    if [[ "$sshConfigUsed" == "personal" ]]; then
        return
    fi
	export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_personal_gh -F /dev/null"
    echo "switching to personal-ssh"
    if [ $# -gt 0 ]; then
    	setupgitpersonal $1
    fi
    sshConfigUsed=personal
}

switchSshBasedOnDir() {
    if [[ "$PWD" == *"/olivier-setup" || "$PWD" == "$HOME/personal/"* ]]; then
        switchsshpersonal
    else
        switchsshwork
    fi
}
```

### Adding to the script - tmux startup script

Can add a tmux starting script, like the one below, can make it available to call from the shell.

```
tmuxW() {
    tmux has-session -t work 2> /dev/null
    if [ $? -eq 0 ]; then
        echo "tmux work session already found. Attaching to it"
        tmux a -t work
        return
    fi
    echo "tmux work session not found. Creating it"
    tmux new-session -s work -n work-cli -d
    tmux send-keys -t work:work-cli.0 "cd ~/workspace/rvezy-web-client-v3/ && launchdev -a w" C-m #rvezy-web-client-v3
    tmux split-pane -v -t work:work-cli
    tmux send-keys -t work:work-cli.1 "cd ~/workspace/Operations-Dashboard/ && launchdev -a o" C-m #operations-dashboard
    tmux split-window -h -t work:work-cli
    tmux send-keys -t work:work-cli.2 "cd ~/workspace/rvezy-back-end/ && launchdev -a b" C-m #rvezy-back-end
    tmux new-window -n work-nvim 
    tmux send-keys -t work:work-nvim "nvimW" C-m #nvim
    tmux a -t work
}
```

## nvim setup

### Workspace

put a startup script which starts all your working directories in `lua/not_pushed/work_startup.lua`
the script will look something like 

```
local directories = {
    "~/olivier-setup/",
    "~/workspace/project-1/",
	"~/workspace/project-2/",
    "~/workspace/project-3/",
}

for idx, directory in pairs(directories) do
    if (idx > 1) then
        vim.cmd("tabnew")
    end
    vim.cmd("tcd " .. directory)
end
vim.cmd("tabn 1")
```

then set a shell alias as below in your extra_zshrc.zsh file

```
alias nvimW="nvim -S ~/.config/nvim/lua/not_pushed/work_startup.lua"
```


### commands to run on opening a file from certain directories

Put a lua file in `lua/not_pushed/buf_read_pre_config.lua` with the following content of format like this
Example to hide a problematic directory from telescope live grep

```
local set_telescope_mapping = function()
    local buf = vim.api.nvim_get_current_buf()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep { glob_pattern = "!vendor/*" } end, { buffer = buf, noremap = true, silent = true, })
end


table.insert(buf_read_pre_config_list, {
	command = set_telescope_mapping,
	filetypes = { "vue", "js", "mjs", "cjs" },
	dir_path = "~/workspace/rvezy-web-client-v3",
})
```

### Neoformat/commands to run on save config from certain directories

Put a lua file in `lua/not_pushed/buf_write_pre_config.lua` with the following content of format like this
(same format as the one above)

```
local buf_write_pre_config_list = {}
table.insert(buf_write_pre_config_list, {
	command = "Neoformat black",
	filetypes = { "py" },
	dir_path = "~/personal",
})
table.insert(buf_write_pre_config_list, {
	command = "Neoformat prettier",
	filetypes = { "vue", "js", "mjs", "cjs" },
	dir_path = "~/workspace/rvezy-web-client-v3",
})
table.insert(buf_write_pre_config_list, {
	command = "EslintFixAll",
	filetypes = { "vue", "js", "mjs", "cjs" },
	dir_path = "~/workspace/rvezy-web-client",
})
return buf_write_pre_config_list
```

### C# setup

Put values for C# project configs in `csharp_project_configs` in the `nvim/plugin/not_pushed` folder. 

For Example:

```
csharp_project_configs = {}
table.insert(csharp_project_configs,
	{
        name = 'Rvezy.Api',
        build_path = 'RVezy.Api',
        path = '/Users/oliviertrahan/workspace/rvezy-back-end/RVezy.Api/bin/Debug/net7.0/RVezy.Api.dll'
    }
)
```
