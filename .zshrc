#always keep this at the beggining of the file
if [ -e ~/common_bashrc.sh ]; then
    source ~/common_bashrc.sh
fi

# Helpful aliases
alias zshr="exec zsh"

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

[ -e ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

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

add-zsh-hook chpwd auto_python_venv
auto_python_venv  # also run once on startup

autoload -Uz kill_program_by_name 
autoload -Uz setupgitpersonal 
autoload -Uz fuzzy_find_staged_files
autoload -Uz fuzzy_find_modified_files
autoload -Uz add_review_branch

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -e ~/.p10k.zsh ]] || source ~/.p10k.zsh

which zoxide > /dev/null && eval "$(zoxide init zsh)"

# fzf shell integration
if [ -e ~/.fzf.zsh ]; then
  which fzf > /dev/null && source ~/.fzf.zsh
fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#always keep this at end of file
if [ -e ~/extra_zshrc.zsh ]; then
    source ~/extra_zshrc.zsh
fi
