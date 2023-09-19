replace_file_and_link() {
  [ ! -L "$2" ] && [ -f "$2" ] && mv "$2" "$2.bak" && echo "Backed up $2 to $2.bak"
  if [ ! -L "$2" ]; then
    ln -sf "$1" "$2" && echo "Linked $1 to $2"
  else
    echo "$1 already linked to $2"
  fi
}

replace_directory_and_link() {
  [ ! -L "$2" ] && [ -d "$2" ] && mv "$2" "$2.bak" && echo "Backed up $2 to $2.bak"
  if [ ! -L "$2" ]; then
    ln -sf "$1" "$2" && echo "Linked $1 to $2"
  else
    echo "$1 already linked to $2"
  fi
}

which brew || sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
which zsh || (brew install zsh && chsh -s $(which zsh))
which rg || brew install ripgrep
which jq || brew install jq
which tmux || brew install tmux
which code || brew install --cask visual-studio-code #fuck it why not
which npm || brew install npm
#which nvm || brew install nvm
which thefuck || brew install thefuck
brew list iterm2 || brew install iterm2
brew tap homebrew/cask-fonts
brew list font-fira-code || brew install --cask font-fira-code
#Then go in iTerm2 Preferences > Profiles > Text -> Change font to "Hack Nerd Font"

#Neovim setup
which nvim || brew install neovim
if [ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
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
replace_file_and_link "$(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh" ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
replace_directory_and_link "$(pwd)/nvim" ~/.config/nvim

[ -f ./extra-mac-setup.sh ] && chmod +x ./extra-mac-setup.sh && ./extra-mac-setup.sh

source ~/.zshrc