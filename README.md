# olivier-setup

Run `$ source mac-setup.sh` to setup your mac ready for local dev

- the `.zshrc` is the base provided which is universal to my personal config
- the `nvim` folder gets symlinked to the nvim config folder
- an `extra_zshrc` file may be placed at the project root for secret values that we don't want pushed to the repo
- an `extra-mac-setup.sh` script may be placed at the project root for a secret script that we don't want pushed to the repo. This is ran at the end of the `mac-setup.sh` script
