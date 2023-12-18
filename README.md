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

### Adding to the script

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

## nvim setup

### Workspace

put a startup script which starts all your working directories in `lua/not_pushed/startup.lua`
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

then set a shell alias as below

```
alias nvimS="nvim -S ~/.config/nvim/lua/not_pushed/startup.lua"
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
