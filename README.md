# Andrew Allbright dotfiles
Personal dotfiles. This is an upgrade from my ansible based computer setup scripts.

## Manual Hacks
Documenting the manual hacks in order to later automate.

```bash
# Install homebrew
# source: https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install files from Brewfile
brew bundle install --file ./homebrew/Brewfile
brew bundle check --file ./homebrew/Brewfile

# Install .oh-my-zsh
# source: https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Symlink files
ln -s $(pwd)/.zshrc $HOME/.zshrc
ln -s $(pwd)/.gitconfig $HOME/.gitconfig
ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf
mkdir -p $HOME/.ssh
ln -s $(pwd)/ssh/config $HOME/.ssh/config
```
