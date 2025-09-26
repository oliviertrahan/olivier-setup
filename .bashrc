alias bashr="source $HOME/.bashrc"

# For windows git bash, need to make symlinks actually be symlinks like you would expect them to work on linux / macOS
export MSYS="winsymlinks:nativestrict"


#always keep this at the beggining of the file
if [ -e ~/common_bashrc.sh ]; then
    source ~/common_bashrc.sh
fi

#always keep this at end of file
if [ -e ~/extra_bashrc.sh ]; then
    source ~/extra_bashrc.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
