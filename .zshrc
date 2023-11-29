#Homebrew paths on M1 Macs
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
    # git
    # npm
    #autoswitch_virtualenv
    # aws
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
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export EDITOR="nvim"
export VISUAL="nvim -R"
export PAGER="nvim +Man!"
export MANPAGER="nvim +Man!" 
export VSCODE_DEBUG='1'
#export LOCAL_IP=$(ipconfig getifaddr en0)

# place this after nvm initialization!
# autoload -U add-zsh-hook
# load-nvmrc() {
#   if [[ -f .nvmrc && -r .nvmrc ]]; then
#     nvm use 
#   elif [[ $(nvm version) != $(nvm version default)  ]]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc

# Helpful aliases
alias vshedit="nvim ~/.zshrc"
alias vimedit="nvim ~/.vimrc"
alias zshedit="code ~/.zshrc"
alias tmuxedit="nvim ~/.tmux.conf"
alias zshreload="exec zsh"

#ruby 2 doesn't have gem exec command
if [[ $(ruby --version) == 'ruby 2'* ]]; then
    alias ls="colorls"
else
    alias ls="gem exec colorls"
fi


#dotnet aliases
alias dtf="dotnet test --filter"
alias dema="dotnet ef migrations add"
alias dedu="dotnet ef database update"
alias db="dotnet build"

# git aliases
fuzzy_find_staged_files() {
    git --no-pager diff --name-only --cached | fzf
}

fuzzy_find_modified_files() {
    git ls-files -m | fzf
}
autoload -Uz fuzzy_find_staged_files
autoload -Uz fuzzy_find_modified_files

alias gsfs='fuzzy_find_staged_files'
alias gmfs='fuzzy_find_modified_files'
alias ga='fuzzy_find_modified_files | xargs git add'
alias grh='fuzzy_find_staged_files | xargs git reset'
alias grhh='fuzzy_find_modified_files | xargs git reset --hard'
alias gcof='fuzzy_find_modified_files | xargs git checkout'
alias grevf='fuzzy_find_modified_files | xargs git checkout origin/master --'
alias gdf='fuzzy_find_modified_files | xargs git diff'

alias gs="git status"
alias gf="git fetch"
alias gm="git merge"
alias gp="git push"
alias gpf='git push --force-with-lease'
alias gP="git pull"
alias gup="git pull"
alias gd='git diff'
alias gdt='git difftool'
alias gdca='git diff --cached'
alias gcp='git cherry-pick'
alias gco="git checkout"
alias gcm="git checkout master"
alias gcb='git checkout -b'
alias grevm="git checkout origin/master --"
alias glog="git log"
alias gaa='git add --all'
alias gbd='git branch -d'
alias gbD='git branch -D' 
alias gcom="git commit"
alias gcomm="git commit -m "
alias gsta='git stash'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gclean='git clean -fd'

git config --global core.editor $(which nvim)
git config --global core.pager "nvim +Man!"

export PATH=/Users/oliviertrahan/.local/bin:$PATH
export HOMEBREW_NO_INSTALL_CLEANUP=

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $(dirname $(gem which colorls))/tab_complete.sh


