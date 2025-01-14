#Homebrew paths on M1 Macs
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZVM_INIT_MODE=sourcing

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "xiong-chiamiov-plus", "powerlevel10k/powerlevel10k" )

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# for zsh-vi-mode escaping insert mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# User configuration

eval $(thefuck --alias)
unsetopt share_history

export PATH="/usr/local/bin/code:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH" 
export PATH="$HOME/netcoredbg/netcoredbg:$PATH" 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="nvim"
export VISUAL="nvim -R"
export PAGER="nvim +Man!"
export MANPAGER="nvim +Man!" 
export VSCODE_DEBUG='1'
#export LOCAL_IP=$(ipconfig getifaddr en0)

kill_program_by_name() {
    ps -a | grep $1 | grep -v grep | awk '{print $1}' | xargs kill -9
}

autoload -Uz kill_program_by_name 

# Helpful aliases
alias zshreload="exec zsh"
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

autoload -Uz setupgitpersonal 
fuzzy_find_staged_files() {
    git --no-pager diff --name-only --cached | fzf
}

fuzzy_find_modified_files() {
    git ls-files -m --others --exclude-standard | fzf
}

autoload -Uz fuzzy_find_staged_files
autoload -Uz fuzzy_find_modified_files

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

autoload -Uz add_review_branch

alias gsfs="fuzzy_find_staged_files"
alias gmfs="fuzzy_find_modified_files"
alias gaf="fuzzy_find_modified_files | xargs git add"
alias grhf="fuzzy_find_staged_files | xargs git reset"
alias grhhf="fuzzy_find_modified_files | xargs git reset --hard"
alias gcof="fuzzy_find_modified_files | xargs git checkout"
alias grevmf="fuzzy_find_modified_files | xargs git checkout origin/master --"
alias grevb="git_select_from_latest_branch | xargs -I {} git checkout {} --"
alias grevob="git_select_from_latest_origin_branch | xargs -I {} git checkout {} --"
alias gdf="fuzzy_find_modified_files | xargs git diff"
alias gdtf="fuzzy_find_modified_files | xargs git difftool"
alias gcbf="git_select_from_latest_branch | xargs git checkout"
alias gmf="git_select_from_latest_branch | xargs git merge"
alias gmof="git_select_from_latest_origin_branch | xargs git merge"
alias grbf="git_select_from_latest_branch | xargs git rebase"
alias grbof="git_select_from_latest_origin_branch | xargs git rebase"
alias gcbof="git_select_from_latest_origin_branch | sed -e 's/^[ 	]*origin\///' | xargs git checkout"
alias gcleanf="git ls-files --others --exclude-standard | fzf | xargs git clean -fd"
alias gbDf="git_select_from_oldest_branch | tee ~/branch.txt | xargs git branch -D; cat ~/branch.txt | xargs git push origin --delete; rm ~/branch.txt"
alias gstaf="fuzzy_find_modified_files | xargs git stash push"

gp() {
    if [ $# -gt 0 ]; then
        git add --all
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
alias gcleanall="git clean -fd"


git config --global core.editor $(which nvim)
git config --global core.pager "nvim +Man!"
git config --global difftool.prompt false
git config --global push.autoSetupRemote true

# End settings

export PATH=/Users/oliviertrahan/.local/bin:$PATH
export HOMEBREW_NO_INSTALL_CLEANUP=
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -e ~/.p10k.zsh ]] || source ~/.p10k.zsh

which zoxide > /dev/null && eval "$(zoxide init zsh)"

# fzf shell integration
if [ -e ~/.fzf.zsh ]; then
  which fzf > /dev/null && source ~/.fzf.zsh
fi

#always keep this at end of file
if [ -e ~/extra_zshrc.zsh ]; then
    source ~/extra_zshrc.zsh
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
