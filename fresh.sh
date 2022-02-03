#!/usr/bin/env bash

if ! stat ${HOME}/.oh-my-zsh &> /dev/null ; then
  # Install .oh-my-zsh
  # source: https://github.com/ohmyzsh/ohmyzsh
  echo "🖥 Installing oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! stat ${HOME}/.zshrc &> /dev/null || [[ ! -L ${HOME}/.zshrc ]] ; then
  echo "🪓 Clearing non symbolic link shell profile"
  rm ${HOME}/.zshrc

  echo "🪱 Symlinking shell profile"
  ln -s $(pwd)/.zshrc ${HOME}/.zshrc
fi

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

if ! stat ${HOME}/Brewfile &> /dev/null || [[ ! -L ${HOME}/Brewfile ]] ; then
  echo "🪓 Clearing non symbolic link Brewfile (if exists)"
  rm ${HOME}/Brewfile
  echo "🪱 Symlinking Brewfile"
  ln -s $(pwd)/Brewfile ${HOME}/Brewfile
fi

if ! stat ${HOME}/.gitconfig &> /dev/null || [[ ! -L ${HOME}/.gitconfig ]] ; then
  echo "🪓 Clearing non symbolic link .gitconfig (if exists)"
  rm ${HOME}/.gitconfig
  echo "🪱 Symlinking .gitconfig"
  ln -s $(pwd)/.gitconfig ${HOME}/.gitconfig
fi

if ! stat ${HOME}/.tmux.conf &> /dev/null || [[ ! -L ${HOME}/.tmux.conf ]] ; then
  echo "🪓 Clearing non symbolic link .tmux.conf (if exists)"
  rm ${HOME}/.tmux.conf
  echo "🪱 Symlinking .tmux.conf"
  ln -s $(pwd)/.tmux.conf ${HOME}/.tmux.conf
fi

if [[ ! -d ${HOME}/.ssh ]] ; then
  echo "📂 Creating .ssh directory"
  mkdir -p ${HOME}/.ssh
fi

if ! stat ${HOME}/.ssh/config &> /dev/null || [[ ! -L ${HOME}/.ssh/config ]] ; then
  echo "🪓 Clearing non symbolic link .ssh/config (if exists)"
  rm ${HOME}/.ssh/config
  echo "🪱 Symlinking .ssh/config"
  ln -s $(pwd)/ssh/config ${HOME}/.ssh/config
fi

source ./.macos
