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

bash_version=$(bash --version)
current_pwd=$(pwd)
# if [[ $bash_version =~ "version 3." ]]; then
#   echo "must update bash. Updating"
#   cd /tmp/
#   if [ ! -e /tmp/bash-4.4.12 ]; then
#     curl -O http://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz
#     tar xzf bash-4.4.12.tar.gz
#   fi
#   cd bash-4.4.12
#   ./configure --prefix=/usr/local
#   make
#   sudo make install
# else
#   echo "bash updated enough."
# fi

defaults write com.apple.finder AppleShowAllFiles TRUE

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

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

#Neovim setup
which nvim || brew install neovim
if [ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

if [ ! -e $ZSH_CUSTOM/plugins/zsh-vi-mode ]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode \
        $ZSH_CUSTOM/plugins/zsh-vi-mode
fi

if [ ! -e $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cat ./.zshrc > ./output_zshrc
cat ./extra_zshrc >> ./output_zshrc

replace_file_and_link "$(pwd)/output_zshrc" ~/.zshrc
replace_file_and_link "$(pwd)/.tmux.conf" ~/.tmux.conf

if [ ! -e ~/.zsh ]; then
  mkdir ~/.zsh
fi
replace_file_and_link "$(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh" ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

if [ ! -e ~/.config ]; then
  mkdir ~/.config
fi
replace_directory_and_link "$(pwd)/nvim" ~/.config/nvim

[ -f ./extra-mac-setup.sh ] && chmod +x ./extra-mac-setup.sh && ./extra-mac-setup.sh

source ~/.zshrc
