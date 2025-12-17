#!/usr/bin/env bash
# Uninstall script is meant to reverse the order of the install script
# Currently, that is the responsibility of the developer/s working on the
# project.

echo "🦉 Uninstall script"

if [[ -L "${HOME}"/.vimrc ]] ; then
  echo "🪓 Deleting .vimrc"
  rm "${HOME}"/.vimrc
fi

if [[ -L "${HOME}"/.ssh/config ]] ; then
  echo "🪓 Deleting .ssh/config"
  rm "${HOME}"/.ssh/config
fi

if [[ -e "${HOME}"/.ssh ]] ; then
  echo "❌ it is up to the user to delete .ssh"
fi


if [[ -L "${HOME}"/.tmux.conf ]] ; then
  echo "🪓 Deleting .tmux.conf"
  rm "${HOME}"/.tmux.conf
fi

if [[ -L "${HOME}"/.gitconfig ]] ; then
  echo "🪓 Deleting .gitconfig"
  rm "${HOME}"/.gitconfig
fi

if [[ -e "${HOME}"/.untracked-gitconfig ]] ; then
  echo "❌ it is up to the user to delete .untracked-gitconfig"
fi

echo "❌ it is up to the user to delete remove homebrew installation"

if [[ -L "${HOME}"/.zshrc ]] ; then
  echo "🪓 Deleting .zshrc"
  rm "${HOME}"/.zshrc
fi

if [[ -L "${HOME}"/.aliases ]] ; then
  echo "🪓 Deleting .aliases"
  rm "${HOME}"/.aliases
fi

if [[ -L "${HOME}"/.profile ]] ; then
  echo "🪓 Deleting .profile"
  rm "${HOME}"/.profile
fi
