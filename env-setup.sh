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

    which rg || brew install ripgrep
    which jq || brew install jq
    which tmux || brew install tmux
    which code || brew install --cask visual-studio-code #fuck it why not
    which npm || brew install npm
    #which nvm || brew install nvm
    which thefuck || brew install thefuck
    brew list iterm2 || brew install iterm2
    brew tap homebrew/cask-fonts
    brew list font-hack-nerd-font || brew install --cask font-hack-nerd-font
    #Then go in iTerm2 Preferences > Profiles > Text -> Change font to "Hack Nerd Font"
    which fzf || brew install fzf

    if [[ "$(which ruby)" != *"homebrew"* ]]; then  
        brew install ruby
		export PATH="/opt/homebrew/opt/ruby/bin:$PATH" 
        gem info colorls | grep 'colorls' || sudo gem install colorls
    fi

    if [ ! -d "~/netcoredbg" ]; then
        mkdir ~/netcoredbg
        wget -P ~/netcoredbg/ "https://github.com/Samsung/netcoredbg/releases/download/3.0.0-1012/netcoredbg-osx-amd64.tar.gz"
        cd ~/netcoredbg/
        tar -xf netcoredbg-osx-amd64.tar.gz
        cd netcoredbg
        chmod +x netcoredbg
        find * | xargs xattr -r -d com.apple.quarantine
    fi
}

linux_install() {
    # Currently assuming a Debian-based distro
    which rg || sudo apt-get install ripgrep
    which jq || sudo apt-get install jq
    which tmux || sudo apt-get install tmux
    which code || sudo apt-get install visual-studio-code #fuck it why not
    which npm || sudo apt-get install npm
    which thefuck || sudo apt-get install thefuck
    #Might need a patched font here
    which fzf || sudo apt-get install fzf
    which colorls || sudo gem install colorls
}

bash_version=$(bash --version)
current_pwd=$(pwd)

if [[ $update_only_links == 0 ]]; then

    if [[ "$machine" == "Mac" ]]; then
        mac_install
    else 
        linux_install
    fi

    #Neovim setup
    which nvim || brew install neovim
    if [ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
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

#Combining files and linking

cat ./.zshrc > ./output_zshrc.zsh
if [ -e ./extra_zshrc.zsh ]; then
  echo "Found extra_zshrc.zsh. Appending to output_zshrc.zsh"
  cat ./extra_zshrc.zsh >> ./output_zshrc.zsh
else
    echo "No extra_zshrc.zsh found"
fi

replace_file_and_link "$(pwd)/output_zshrc.zsh" ~/.zshrc
replace_file_and_link "$(pwd)/.tmux.conf" ~/.tmux.conf
replace_file_and_link "$(pwd)/.p10k.zsh" ~/.p10k.zsh

if [ ! -e ~/.zsh ]; then
  mkdir ~/.zsh
fi
replace_file_and_link "$(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh" ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

if [ ! -e ~/.config ]; then
  mkdir ~/.config
fi
replace_directory_and_link "$(pwd)/nvim" ~/.config/nvim

[ -f ./extra-mac-setup.sh ] && chmod +x ./extra-mac-setup.sh && ./extra-mac-setup.sh

exec zsh
