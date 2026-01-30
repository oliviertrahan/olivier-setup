#Homebrew paths on M1 Macs
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

machine=
pathStyle=
unameOut="$(uname -s)"

# All unix path styles for now
case "${unameOut}" in
    Linux*)     machine=Linux; pathStyle=unix;;
    Darwin*)    machine=Mac; pathStyle=unix;;
    MINGW64*)   machine=Windows; pathStyle=unix;;
    MSYS_NT*)   machine=Windows; pathStyle=unix;;
    CYGWIN_NT*) machine=Windows; pathStyle=unix;;
    *)          machine=;;
esac

# All unix path styles should be bash compatible
if [ "$pathStyle" == "unix" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Making symlinks work on windows for MSYS environments
#export MSYS=winsymlinks:lnk
export MSYS=winsymlinks:nativestrict

# every env will use nvim as editor
export EDITOR="nvim"
export VISUAL="nvim -R"
export PAGER="nvim +Man!"
export MANPAGER="nvim +Man!" 
export VSCODE_DEBUG='1'
export CYGWIN=winsymlinks:nativestrict


# XDG Base Directory Specification
# Forcing windows based unix environments to this, whereas mac/linux would just be like this by default
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
#export LOCAL_IP=$(ipconfig getifaddr en0)

kill_program_by_name() {
    ps -a | grep $1 | grep -v grep | awk '{print $1}' | xargs kill -9
}

auto_python_venv() {
    if [ -f "venv/bin/activate" ]; then
        # Only activate if not already active
        if [ "$VIRTUAL_ENV" != "$(pwd)/venv" ]; then
            echo "Activating venv in $(pwd)/venv"
            source venv/bin/activate
        fi
    fi
}
auto_python_venv  # also run once on startup

# Helpful aliases
alias killNvim="kill_program_by_name('nvim')"
alias fopen="nvim -c \"lua require('telescope.builtin').find_files({ find_command={ 'rg', '--files', '--hidden', '--smart-case', '-g', '!.git' } })\""

mvFromTo() {
    cwd=$(pwd)
    startfolder=$1
    destination=$2

    cd $startfolder
    selection=$(pwd)/$(fzf)
    echo "selection: $selection"
    cd -
    destination=$(find . -type d -print | fzf)
    mv $selection $destination
}
alias mvDl="mvFromTo ~/Downloads $PWD"


# git configs
setupgitpersonal() {
    if [ $# -eq 1 ]; then
        echo "Setting up global git config"
        git config --global user.name oliviertrahan
        git config --global user.email trahan.olivier@gmail.com
    else 
        echo "Setting up local git config"
        git config user.name oliviertrahan
        git config user.email trahan.olivier@gmail.com
    fi
}


git_get_main_branch() {
    if git show-ref --quiet refs/heads/main; then
        echo "main"
    else
        echo "master"
    fi
}

fuzzy_find_staged_files() {
    git --no-pager diff --name-only --cached | fzf
}

fuzzy_find_staged_file_directories() {
    git --no-pager diff --name-only --cached \
        | xargs -r dirname \
        | sort -u \
        | fzf
}


fuzzy_find_modified_files() {
    git ls-files -m --others --exclude-standard | fzf
}

fuzzy_find_modified_file_directories() {
    git ls-files -m --others --exclude-standard \
        | xargs -r dirname \
        | sort -u \
        | fzf
}

fuzzy_find_cleanable_files() {
    git ls-files --others --exclude-standard | fzf  
}

fuzzy_find_cleanable_file_directories() {
    git ls-files --others --exclude-standard \
        | xargs -r dirname \
        | sort -u \
        | fzf  
}

git_select_from_latest_branch() {
    git --no-pager branch -l --sort=-committerdate | fzf
}

git_select_from_latest_origin_branch() {
    git --no-pager branch -lr --sort=-committerdate | fzf
}

git_select_from_oldest_branch() {
    git --no-pager branch -l --sort=committerdate | fzf
}

add_review_branch() {
    git_select_from_latest_origin_branch | sed -e 's/^[ 	]*origin\///' | xargs -I {} git worktree add -f ../$(basename "$PWD")-review {}
}

alias killf="ps aux | fzf | awk '{print $2}' | xargs kill -9"

alias gs="git status"
alias ga="git add"
alias gf="git fetch"
alias gm="git merge"
alias grb="git rebase"
alias gpf="git push --force-with-lease"
alias gP="git pull"
alias gup="git pull"
alias gd="git diff"
alias gdt="git difftool"
alias gdca="git diff --cached"
alias gcp="git cherry-pick"
alias gco="git checkout"
alias gcm="git checkout $(git_get_main_branch)"
alias gcb="git checkout -b"
alias grh="git reset"
alias grhh="git reset --hard"
alias grevm="git checkout origin/$(git_get_main_branch) --"
alias glog="git log"
alias gaa="git add --all"
alias gbd="git branch -d"
alias gbD="git branch -D" 
alias gcom="git commit"
alias gcomm="git commit -m "
alias gsta="git stash"
alias gstc="git stash clear"
alias gstd="git stash drop"
alias gstl="git stash list"
alias gstp="git stash pop"
alias grbc="git rebase --continue"
alias gcleanall="git clean -fd"
alias gsquash="git fetch && git reset --soft origin/$(git_get_main_branch)"

alias gsfs="fuzzy_find_staged_files"
alias gmfs="fuzzy_find_modified_files"
alias gaf="fuzzy_find_modified_files | xargs -r -I {} git add \"{}\""
alias gafd="fuzzy_find_modified_file_directories | xargs -r -I {} git add \"{}\""
alias grhf="fuzzy_find_staged_files | xargs -r -I {} git reset \"{}\""
alias grhfd="fuzzy_find_staged_file_directories | xargs -r -I {} git reset \"{}\""
alias grhhf="fuzzy_find_modified_files | xargs -r -I {} git reset --hard \"{}\""
alias grhhfd="fuzzy_find_modified_file_directories | xargs -r -I {} git reset --hard \"{}\""
alias gcof="fuzzy_find_modified_files | xargs -r -I {} git checkout \"{}\""
alias gcofd="fuzzy_find_modified_file_directories | xargs -r -I {} git checkout \"{}\""
alias grevmf="fuzzy_find_modified_files | xargs -r -I {} git checkout origin/$(git_get_main_branch) -- \"{}\""
alias grevmfd="fuzzy_find_staged_file_directories | xargs -r -I {} git checkout origin/$(git_get_main_branch) -- \"{}\""
alias grevb="git_select_from_latest_branch | xargs -r -I {} git checkout \"{}\" --"
alias grevob="git_select_from_latest_origin_branch | xargs -r -I {} git checkout \"{}\" --"
alias gdf="fuzzy_find_modified_files | xargs -r -I {} git diff \"{}\""
alias gdmf="fuzzy_find_modified_files | xargs -r -I {} git diff \"origin/$(git_get_main_branch):{}\" \"{}\""
alias gdaf="fuzzy_find_staged_files | xargs -r -I {} git diff \"{}\""
alias gdfd="fuzzy_find_modified_file_directories | xargs -r -I {} git diff \"{}\""
alias gdtf="fuzzy_find_modified_files | xargs -r -I {} git difftool \"{}\""
alias gdtfd="fuzzy_find_modified_file_directories | xargs -r -I {} git difftool \"{}\""
alias gcbf="git_select_from_latest_branch | xargs -r -I {} git checkout \"{}\""
alias gmf="git_select_from_latest_branch | xargs -r -I {} git merge \"{}\""
alias gmof="git_select_from_latest_origin_branch | xargs -r -I {} git merge \"{}\""
alias grbf="git_select_from_latest_branch | xargs -r -I {} git rebase \"{}\""
alias grbof="git_select_from_latest_origin_branch | xargs -r -I {} git rebase \"{}\""
alias grbonf="git_select_from_latest_origin_branch | xargs -r -I {} git rebase --onto origin/$(git_get_main_branch) \"{}\""
alias gcbof="git_select_from_latest_origin_branch | sed -e 's/^[ 	]*origin\///' | xargs -r git checkout"
alias gcleanf="fuzzy_find_cleanable_files | xargs -r -I {} git clean -fd \"{}\""
alias gcleanfd="fuzzy_find_cleanable_file_directories | xargs -r -I {} git clean -fd \"{}\""
alias gbDf="git_select_from_oldest_branch | tee ~/branch.txt | xargs -r git branch -D; cat ~/branch.txt | xargs -r git push origin --delete; rm ~/branch.txt"
alias gstaf="fuzzy_find_modified_files | xargs -r -I {} git stash push \"{}\""
alias gstafd="fuzzy_find_modified_file_directories | xargs -r -I {} git stash push \"{}\""
alias grmf="fuzzy_find_modified_files | xargs -r -I {} git rm \"{}\""
alias grmfd="fuzzy_find_modified_file_directories | xargs -r -I {} git rm \"{}\""
alias gsquashb="git fetch && git_select_from_latest_origin_branch && xargs -r -I {} git reset --soft \"origin/{}\""

gp() {
    if [ $# -eq 1 ]; then
        git commit -m "$1" && git push
    elif [ $# -eq 2 ]; then # a bit hacky, but allows me to pass an additional flag to the commit command
        git commit -m "$1" "$2" && git push
    else
        git push
    fi
}



fail() {
    $(exit 1)
}

success() {
    $(exit 0)
}

notify() {
    if [ $# -eq 0 ]; then
        echo "Usage: notify <commands>. Will execute the command you provide after this as if you didn't type notify, then notify you when it's done"
        return
    fi

    task_name=$1 
    
    # This executes the program
    $@
    if [ $? -eq 0 ]; then
        str_append="successful"
    else
        str_append="failed"
    fi
    
    if which terminal-notifier > /dev/null; then
        terminal-notifier -title "Terminal task completed" -message "command \"${*}\" $str_append"
    fi
    
    if which say > /dev/null; then
        say "task $task_name $str_append"
    fi
}

# Git global settings
 
# Machine != windows is really WSL, only tested for that
# if [ "$machine" != "Windows" ]; then
#     git config --global core.filemode false
#     git config --global core.autocrlf true
# else
#     git config --global core.autocrlf false
# fi

git config --global --replace-all core.editor nvim
git config --global core.pager "nvim +Man!"
git config --global difftool.prompt false
git config --global diff.tool nvimdiff
git config --global push.autoSetupRemote true

# End settings
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export HOMEBREW_NO_INSTALL_CLEANUP=
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=


# bun
if [ -e "$HOME/.bun/bin/bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

