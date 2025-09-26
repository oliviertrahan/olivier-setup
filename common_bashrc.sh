#Homebrew paths on M1 Macs
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

machine=
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    MINGW64*)   machine=Windows;;
    CYGWIN_NT*) machine=Windows;;
    *)          machine=;;
esac

# User configuration

if [ "$machine" != "Windows" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

export EDITOR="nvim"
export VISUAL="nvim -R"
export PAGER="nvim +Man!"
export MANPAGER="nvim +Man!" 
export VSCODE_DEBUG='1'
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

alias gsfs="fuzzy_find_staged_files"
alias gmfs="fuzzy_find_modified_files"
alias gaf="fuzzy_find_modified_files | xargs -r git add"
alias gafd="fuzzy_find_modified_file_directories | xargs -r git add"
alias grhf="fuzzy_find_staged_files | xargs -r git reset"
alias grhfd="fuzzy_find_staged_file_directories | xargs -r git reset"
alias grhhf="fuzzy_find_modified_files | xargs -r git reset --hard"
alias grhhfd="fuzzy_find_modified_file_directories | xargs -r git reset --hard"
alias gcof="fuzzy_find_modified_files | xargs -r git checkout"
alias gcofd="fuzzy_find_modified_file_directories | xargs -r git checkout"
alias grevmf="fuzzy_find_modified_files | xargs -r git checkout origin/master --"
alias grevmfd="fuzzy_find_staged_file_directories | xargs -r git checkout origin/master --"
alias grevb="git_select_from_latest_branch | xargs -r -I {} git checkout {} --"
alias grevob="git_select_from_latest_origin_branch | xargs -r -I {} git checkout {} --"
alias gdf="fuzzy_find_modified_files | xargs -r git diff"
alias gdaf="fuzzy_find_staged_files | xargs -r git diff"
alias gdfd="fuzzy_find_modified_file_directories | xargs -r git diff"
alias gdtf="fuzzy_find_modified_files | xargs -r git difftool"
alias gdtfd="fuzzy_find_modified_file_directories | xargs -r git difftool"
alias gcbf="git_select_from_latest_branch | xargs -r git checkout"
alias gmf="git_select_from_latest_branch | xargs -r git merge"
alias gmof="git_select_from_latest_origin_branch | xargs -r git merge"
alias grbf="git_select_from_latest_branch | xargs -r git rebase"
alias grbof="git_select_from_latest_origin_branch | xargs -r git rebase"
alias gcbof="git_select_from_latest_origin_branch | sed -e 's/^[ 	]*origin\///' | xargs -r git checkout"
alias gcleanf="fuzzy_find_cleanable_files | xargs -r git clean -fd"
alias gcleanfd="fuzzy_find_cleanable_file_directories | xargs -r git clean -fd"
alias gbDf="git_select_from_oldest_branch | tee ~/branch.txt | xargs -r git branch -D; cat ~/branch.txt | xargs -r git push origin --delete; rm ~/branch.txt"
alias gstaf="fuzzy_find_modified_files | xargs -r git stash push"
alias gstafd="fuzzy_find_modified_file_directories | xargs -r git stash push"
alias grmf="fuzzy_find_modified_files | xargs -r git rm"
alias grmfd="fuzzy_find_modified_file_directories | xargs -r git rm"

gp() {
    if [ $# -gt 0 ]; then
        git commit -m "$1"
    fi

    git push
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
alias gcm="git checkout master || git checkout main"
alias gcb="git checkout -b"
alias grh="git reset"
alias grhh="git reset --hard"
alias grevm="git checkout origin/master --"
alias grevmain="git checkout origin/main --"
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

git config --global core.editor $(which nvim)
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

