#!/bin/bash

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
  if [ -z "$2" ] || [ "$2" = "/" ]; then
      echo "woah! Don't delete everything there bucko. Check how you call replace_directory_and_link and try again"
      return
  fi

  if [ ! -d "$1" ]; then
      echo "$1 is not a directory. Will not link"
      return
  fi
    
  if [ ! -L "$2" ] && [ -d "$2" ]; then
    echo "directory: $2.bak" 
    rm -rf "$2.bak"
    echo "removed"
    mv "$2" "$2.bak"
    echo "Backed up $2 to $2.bak"
  fi
  if [ -L "$2" ]; then
    echo "$1 already linked to $2. Relinking"
    rm $2
  fi
  echo "\$1: $1, \$2: $2"
  ln -sf "$1" "$2" && echo "Linked $1 to $2"
}

machine=
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    MINGW64*)   machine=Windows;;
    CYGWIN_NT*) machine=Windows;;
    *)          machine=;;
esac

if [ -z "$machine" ]; then
    echo "The system with uname value is not supported: $unameOut"
    return
fi

windows_install() {
    which luarocks || winget install luarocks
    which nvim || winget install nvim
    which make || choco install make
    which rg || choco install ripgrep
    which gcc || choco install mingw
    which cygwin || choco install cygwin
}

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
    brew tap homebrew/cask-fonts
    brew list font-hack-nerd-font || brew install --cask font-hack-nerd-font
    which fzf || $(brew install fzf && $(brew --prefix)/opt/fzf/install)
    which nvim || brew install neovim
    which zoxide || brew install zoxide
    which ollama || brew install ollama
    which bun || brew install bun
    which sshpass || brew tap hudochenkov/sshpass && brew install sshpass
    which terminal-notifier || brew install terminal-notifier
    which luarocks || brew install luarocks
    which cmake || brew install cmake
    which bun || curl -fsSL https://bun.sh/install | bash

    
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
    # which node || install_nodejs_deb 
    which pcregrep || sudo apt install pcregrep
    # node_major=$(node --version | pcregrep -io1 '^v([0-9]+)\.')
    # if [ $node_major -le 21 ]; then
    #     echo "node major installed version is $node_major which is too low. Installing" 
    #     install_nodejs_deb
    # else
    #     echo "node major is $node_major which is high enough"
    # fi
    which nvm && nvm --version || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash 
    nvm install stable
    which npm || sudo apt install npm
    which thefuck || sudo apt install thefuck
    #Might need a patched font here
    which fzf || sudo apt install fzf
    which ruby || sudo apt install ruby-full
    which colorls || sudo gem install colorls
    which nvim || sudo apt install neovim
    which zoxide || sudo apt install zoxide
    which ollama || sudo apt install ollama
    which bun || sudo apt install bun
    which sshpass || sudo apt install sshpass
    which sshfs || sudo apt install sshfs
    which luarocks || sudo apt install luarocks
    which cmake || sudo apt install cmake
    which bun || curl -fsSL https://bun.sh/install | bash
}

zsh_install() {
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
}

bash_version=$(bash --version)
current_pwd=$(pwd)

if [[ $update_only_links == 0 ]]; then

    if [[ "$machine" == "Mac" ]]; then
        mac_install
        zsh_install
    elif [[ "$machine" == "Windows" ]]; then
        windows_install
    else 
        linux_install
        zsh_install
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

if [ -e ./extra_bashrc.sh ]; then
    echo "Found extra_bashrc.sh."
    replace_file_and_link "$(pwd)/extra_bashrc.sh" ~/extra_bashrc.sh
else
    echo "No extra_bashrc.sh found"
fi

#link zsh setup
replace_file_and_link "$(pwd)/.bash_profile" ~/.bash_profile
replace_file_and_link "$(pwd)/common_bashrc.sh" ~/common_bashrc.sh
replace_file_and_link "$(pwd)/.bashrc" ~/.bashrc
replace_file_and_link "$(pwd)/.zshrc" ~/.zshrc
replace_file_and_link "$(pwd)/.tmux.conf" ~/.tmux.conf
replace_file_and_link "$(pwd)/.p10k.zsh" ~/.p10k.zsh

if [ ! -e ~/.config ]; then
    mkdir ~/.config
fi

nvim_folder="$HOME/.config/nvim"
if [[ "$machine" == "Windows" ]]; then
    nvim_folder="$HOME/AppData/Local/nvim"
fi
replace_directory_and_link "$(pwd)/scripts" "$HOME/scripts"
replace_directory_and_link "$(pwd)/nvim" "$nvim_folder"
replace_directory_and_link "$(pwd)/zellij" $HOME/.config/zellij

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
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" $HOME/.commonvimrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" $HOME/.vrapperrc
replace_file_and_link "$(pwd)/.ideavimrc" $HOME/.ideavimrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" $HOME/.vimrc
replace_file_and_link "$(pwd)/nvim/common_remaps.vim" $HOME/.vscodevimrc
replace_file_and_link "$(pwd)/.obsidian.vimrc" $HOME/.obsidian.vimrc

# vscode/cursor local settings setup
# file locations for visual studio according to: https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
# file locations are assumed for Cursor based on MacOS experience
if [[ "$machine" == "Mac" ]]; then
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
elif [[ "$machine" == "Linux" ]]; then
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/.config/Code/User/settings.json"
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/.config/Cursor/User/settings.json"
else #Windows
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/AppData/Roaming/Code/User/settings.json"
    replace_file_and_link "$(pwd)/vscodesettings.json" "$HOME/AppData/Roaming/Cursor/User/settings.json"
fi

# zsh setup
if [ ! -e $HOME/.zsh ]; then
  mkdir $HOME/.zsh
fi
replace_file_and_link "$(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh" ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

[ -f ./extra-env-setup.sh ] && chmod +x ./extra-env-setup.sh && ./extra-env-setup.sh

if [[ "$machine" == "Windows" ]]; then
    exec bash
else
    exec zsh
fi
