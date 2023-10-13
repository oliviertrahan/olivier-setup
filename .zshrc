#Homebrew paths on M1 Macs
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/oliviertrahan/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "xiong-chiamiov-plus" )

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

plugins=(
    # git
    npm
    #autoswitch_virtualenv
    aws
    zsh-syntax-highlighting
    zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# for zsh-vi-mode escaping insert mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# User configuration

eval $(thefuck --alias)
unsetopt share_history

export PATH="/usr/local/bin/code:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# Example aliases
alias vshedit="nvim ~/.zshrc"
alias vimedit="nvim ~/.vimrc"
alias zshedit="code ~/.zshrc"
alias tmuxedit="nvim ~/.tmux.conf"
alias zshreload="source ~/.zshrc"
alias sms="source mac-setup.sh"

# git aliases
alias gs="git status"
alias gp="git push"
alias gpf='git push --force-with-lease'
alias gP="git pull"
alias gup="git pull"
alias grh='git reset'
alias grhh='git reset --hard'
alias gd='git diff'
alias gdca='git diff --cached'
alias gcp='git cherry-pick'
alias gco="git checkout"
alias gcb='git checkout -b'
alias grevm="git checkout origin/master --"
alias ga='git add'
alias gaa='git add --all'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gcom="git commit"
alias gcomm="git commit -m "
alias gsta='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#autoload -Uz compinit
#zstyle ':completion:*' menu select
#fpath+=~/.zfunc

export PATH=/Users/oliviertrahan/.local/bin:$PATH
export HOMEBREW_NO_INSTALL_CLEANUP=


