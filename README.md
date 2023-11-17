# olivier-setup

All my personal configs

## zsh and symlink env setup

Run `$ source mac-setup.sh` to setup your mac/linux box ready for local dev

- the `.zshrc` is the base provided which is universal to my personal config
- the `nvim` folder gets symlinked to the nvim config folder
- an `extra_zshrc.zsh` file may be placed at the project root for secret values that we don't want pushed to the repo
- an `extra-mac-setup.zsh` script may be placed at the project root for a secret script that we don't want pushed to the repo. This is ran at the end of the `mac-setup.zsh` script

Note: Run `$ source mac-setup.zsh -l` to only run symlink updates

## nvim setup

Put values for C# project configs in `csharp_project_configs` in the `nvim/after/not_pushed` folder. 

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

