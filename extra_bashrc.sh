sshConfigUsed=

alias dotnet_ef='dotnet ef --project CADdetails.Data --startup-project CADdetailsAPI --context CADdetailsContext'

setupgitwork() {
    if [ $# -eq 1 ]; then
        echo "Setting up global git config"
        git config --global user.name olivier-caddetails
        git config --global user.email olivier@caddetails.com
    else 
        echo "Setting up local git config"
        git config user.name olivier-caddetails
        git config user.email olivier@caddetails.com
    fi
}

switchsshpersonal() {
    if [[ "$sshConfigUsed" == "personal" ]]; then
        return
    fi
	export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_personal -F /dev/null"
    echo "switching to personal-ssh"
    if [ $# -gt 0 ]; then
    	setupgitpersonal $1
    fi
    sshConfigUsed=personal
}

switchsshwork() {
    if [[ "$sshConfigUsed" == "work" ]]; then
        return
    fi
	export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -F /dev/null"
    echo "switching to work-ssh"
    if [ $# -gt 0 ]; then
    	setupgitwork $1
    fi
    sshConfigUsed=work
}

switchSshBasedOnDir() {
    if [[ "$PWD" == *"/olivier-setup" || "$PWD" == "$HOME/personal/"* ]]; then
        switchsshpersonal
    else
        switchsshwork
    fi
}


# Add hook to run switchSshBasedOnDir on directory change
if [ -n "$BASH_VERSION" ]; then
    # For bash
    cd() {
        builtin cd "$@"
        switchSshBasedOnDir
    }
elif [ -n "$ZSH_VERSION" ]; then
    # For zsh
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd switchSshBasedOnDir
fi

alias nvimW="nvim -S ~/.config/nvim/lua/not_pushed/work_startup.lua"

# Run once on startup
switchSshBasedOnDir
