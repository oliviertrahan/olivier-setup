update_only_links=0
OPTIND=1

while getopts "l" opt; do
    case $opt in
        l)
           echo "Only updating links this time"
           update_only_links=1
           ;;
       	*)
           echo "unknown parameter $opt"
           ;;
    esac
done

# Might have to run first run $ xcode-select --install
# Then go to Systen Settings > General > Software Update > Install Command-Line Tools

replace_file_and_link() {
  [ ! -L "$2" ] && [ -f "$2" ] && mv "$2" "$2.bak" && echo "Backed up $2 to $2.bak"
  if [ -L "$2" ]; then
    echo "$1 already linked to $2. Relinking"
    rm $2
  fi
  ln -sf "$1" "$2" && echo "Linked $1 to $2"
}

replace_directory_and_link() {
  [ ! -L "$2" ] && [ -d "$2" ] && mv "$2" "$2.bak" && echo "Backed up $2 to $2.bak"
  if [ -L "$2" ]; then
    echo "$1 already linked to $2. Relinking"
    rm $2
  fi
  ln -sf "$1" "$2" && echo "Linked $1 to $2"
}

machine=
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine=
esac

if [ -z "$machine" ]; then
    echo "The system with uname value is not supported: $unameOut"
    return
fi

mac_install() {
    defaults write com.apple.finder AppleShowAllFiles TRUE
    which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    #Homebrew paths on M1 Macs
    if [ -e /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    which alacritty || brew install --cask alacritty
    which rg || brew install ripgrep
    which fd || brew install fd
    which jq || brew install jq
    which tmux || brew install tmux
    which code || brew install --cask visual-studio-code #fuck it why not
    which npm || brew install npm
    #which nvm || brew install nvm
    which thefuck || brew install thefuck
    brew list iterm2 || brew install iterm2
    brew tap homebrew/cask-fonts
    brew list font-hack-nerd-font || brew install --cask font-hack-nerd-font
    which fzf || brew install fzf && $(brew --prefix)/opt/fzf/install
    which nvim || brew install neovim
    which zoxide || brew install zoxide
    which ollama || brew install ollama
    
    # if [ ! -d ~/open-webui ]; then
    #     cd ~/
    #     git clone https://github.com/open-webui/open-webui.git
    # fi
    
    if [[ "$(which ruby)" != *"homebrew"* ]]; then  
        brew install ruby
		export PATH="/opt/homebrew/opt/ruby/bin:$PATH" 
        gem info colorls | grep 'colorls' || sudo gem install colorls
    fi

    if [ ! -d ~/netcoredbg ]; then
        mkdir ~/netcoredbg
        wget -P ~/netcoredbg/ "https://github.com/Samsung/netcoredbg/releases/download/3.0.0-1018/netcoredbg-osx-amd64.tar.gz"
        cd ~/netcoredbg/
        tar -xf netcoredbg-osx-amd64.tar.gz
        cd netcoredbg
        chmod +x netcoredbg
        find * | xargs xattr -r -d com.apple.quarantine
    fi
}

install_nodejs_deb() {
    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && sudo apt-get install -y nodejs 
}

linux_install() {
    # Currently assuming a Debian-based distro
    which rg || sudo apt install ripgrep
    which fd-find || sudo apt install fd-find
    which jq || sudo apt install jq
    which tmux || sudo apt install tmux
    which code || sudo apt install visual-studio-code #fuck it why not
    which node || install_nodejs_deb 
    which pcregrep || sudo apt install pcregrep
    node_major=$(node --version | pcregrep -io1 '^v([0-9]+)\.')
    if [ $node_major -le 20 ]; then
        echo "node major installed version is $node_major which is too low. Installing" 
        install_nodejs_deb
    else
        echo "node major is $node_major which is high enough"
    fi
    which npm || sudo apt install npm
    which thefuck || sudo apt install thefuck
    #Might need a patched font here
    which fzf || sudo apt install fzf
    which ruby || sudo apt install ruby-full
    which colorls || sudo gem install colorls
    which nvim || sudo apt install neovim
    which zoxide || sudo apt install zoxide
    which ollama || sudo apt install ollama
}

bash_version=$(bash --version)
current_pwd=$(pwd)

if [[ $update_only_links == 0 ]]; then

    if [[ "$machine" == "Mac" ]]; then
        mac_install
    else 
        linux_install
    fi

    #zsh plugins
    if [ -d ~/.oh-my-zsh ]; then
        echo "oh-my-zsh already installed"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi


    if [ ! -e $ZSH_CUSTOM/plugins/zsh-vi-mode ]; then
        git clone https://github.com/jeffreytse/zsh-vi-mode \
            $ZSH_CUSTOM/plugins/zsh-vi-mode
    fi

    if [ ! -e $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]; then
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    fi

    if [ ! -e $ZSH_CUSTOM/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git \
            $ZSH_CUSTOM/plugins/zsh-autosuggestions
    fi

    if [ ! -e ${ZSH_CUSTOM}/themes/powerlevel10k ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            ${ZSH_CUSTOM}/themes/powerlevel10k
    fi
fi

    #Tmux setup
    if [ ! -e  ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm \
            ~/.tmux/plugins/tpm
    fi


if [ -e ./extra_zshrc.zsh ]; then
    echo "Found extra_zshrc.zsh."
    replace_file_and_link "$(pwd)/extra_zshrc.zsh" ~/extra_zshrc.zsh
else
    echo "No extra_zshrc.zsh found"
fi

#link zsh setup
replace_file_and_link "$(pwd)/.zshrc" ~/.zshrc
replace_file_and_link "$(pwd)/.tmux.conf" ~/.tmux.conf
replace_file_and_link "$(pwd)/.p10k.zsh" ~/.p10k.zsh

if [ ! -e ~/.config ]; then
    mkdir ~/.config
fi
replace_directory_and_link "$(pwd)/nvim" ~/.config/nvim

# alacritty setup
if [ ! -e ~/.config/alacritty ]; then
  mkdir ~/.config/alacritty
fi
replace_file_and_link "$(pwd)/alacritty.toml" ~/.config/alacritty/alacritty.toml

if [[ "$machine" == "Mac" ]]; then
    echo "Mac detected. Using mac alacritty overrides"
    replace_file_and_link "$(pwd)/alacritty_mac_overrides.toml" ~/.config/alacritty/overrides.toml
else 
    echo "Non-Mac detected. Using default alacritty overrides"
    replace_file_and_link "$(pwd)/alacritty_default_overrides.toml" ~/.config/alacritty/overrides.toml
fi

# other vim extensions setup
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" ~/.commonvimrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" ~/.vrapperrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" ~/.ideavimrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" ~/.vimrc
replace_file_and_link "$(pwd)/.obsidian.vimrc" ~/.obsidian.vimrc


replace_file_and_link "$(pwd)/nvim/common_remaps.vim" ~/.vimrc

# vscode local settings setup
# file locations according to: https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
if [[ "$machine" == "Mac" ]]; then
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/Library/Application Support/Code/User/settings.json"
elif [[ "$machine" == "Linux" ]]; then
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/.config/Code/User/settings.json"
else #Windows
    replace_file_and_link "$(pwd)/vscodesettings.json" "%APPDATA%\Code\User\settings.json"
fi

# zsh setup
if [ ! -e ~/.zsh ]; then
  mkdir ~/.zsh
fi
replace_file_and_link "$(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh" ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

[ -f ./extra-env-setup.sh ] && chmod +x ./extra-env-setup.sh && ./extra-env-setup.sh

exec zsh
