#!/usr/bin/env bash

setup_osx() {
	source ./.macos

	if ! which brew &> /dev/null ; then
	  # Install homebrew
	  # source: https://brew.sh/
	  echo "📀 Installing homebrew"
	  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	if ! brew bundle check --file ./Brewfile &> /dev/null ; then
	  echo "🥳 Installing from brewfile"
	  brew bundle install --file ./Brewfile
	fi
}

zsh_shell_setup() {
	if [[ "$(uname)" = "Linux" ]]; then
		current_shell=$(grep "^$USER" /etc/passwd | cut -d':' -f7)
		if [[ "$current_shell" != *zsh ]]; then
			if grep -qi 'ubuntu' /etc/os-release; then
				echo "Ubuntu detected. Installing Zsh..."
				sudo apt update
				sudo apt install -y zsh
			fi
			echo "Setting default shell to zsh"
			chsh -s $(which zsh)
		fi
	fi

	if [[ ! -d ~/.oh-my-zsh ]] ; then
	  # Install .oh-my-zsh
	  # source: https://github.com/ohmyzsh/ohmyzsh
	  echo "🖥 Installing oh my zsh"
	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi

	if [[ ! -L ~/.zshrc ]] ; then
	  echo "🪓 Clearing non symbolic link shell profile"
	  mv ~/.zshrc ~/.zshrc.old

	  echo "🪱 Symlinking shell profile"
	  ln -s $(pwd)/.zshrc ~/.zshrc
	fi
}

main() {
	zsh_shell_setup

	# probably don't need to call this out on a fresh install?
	if [[ ! -e ~/.untracked-gitconfig ]] ; then
	  echo "❌ Expected File Not Found: ~/.untracked-gitconfig (pulled in by ~/.gitconfig)"
	fi

	if [[ ! -L ~/.gitconfig ]] ; then
	  echo "🪓 Clearing non symbolic link .gitconfig (if exists)"
	  mv ~/.gitconfig ~/.gitconfig.old
	  echo "🪱 Symlinking .gitconfig"
	  ln -s $(pwd)/.gitconfig ~/.gitconfig
	fi

	if [[ ! -L ~/.tmux.conf ]] ; then
	  echo "🪓 Clearing non symbolic link .tmux.conf (if exists)"
	  mv ~/.tmux.conf ~/.tmux.conf.old
	  echo "🪱 Symlinking .tmux.conf"
	  ln -s $(pwd)/.tmux.conf ~/.tmux.conf
	fi

	if [[ ! -d ~/.ssh ]] ; then
	  echo "📂 Creating .ssh directory"
	  mkdir -p ~/.ssh
	fi

	if [[ ! -L ~/.ssh/config ]] ; then
	  echo "🪓 Clearing non symbolic link .ssh/config (if exists)"
	  mv ~/.ssh/config ~/.ssh/config.old
	  echo "🪱 Symlinking .ssh/config"
	  ln -s $(pwd)/ssh/config ~/.ssh/config
	fi

	if [[ ! -L ~/.vimrc ]] ; then
	  echo "🪓 Clearing non symbolic link .vimrc (if exists)"
	  mv ~/.vimrc ~/.vimrc.old
	  echo "🪱 Symlinking .vimrc"
	  ln -s $(pwd)/.vimrc ~/.vimrc
	fi

	if [ "$(uname)" = "Darwin" ]; then
		setup_osx
	fi
}

main
