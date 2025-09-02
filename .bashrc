alias bashr="source $HOME/.bashrc"
export MSYS="winsymlinks:nativestrict"


#always keep this at the beggining of the file
if [ -e ~/common_bashrc.sh ]; then
    source ~/common_bashrc.sh
fi

#always keep this at end of file
if [ -e ~/extra_bashrc.sh ]; then
    source ~/extra_bashrc.sh
fi
