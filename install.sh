#!/usr/bin/env bash
# Install dotfiles: symlink everything listed in symlinks.txt into $HOME,
# then (unless --links-only / DOTFILES_LINKS_ONLY=1) install oh-my-zsh,
# Homebrew packages, macOS defaults and git hooks.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINKS_ONLY="${DOTFILES_LINKS_ONLY:-0}"
for arg in "$@"; do
	case "$arg" in
		--links-only) LINKS_ONLY=1 ;;
		-h | --help)
			echo "usage: $0 [--links-only]"
			exit 0
			;;
		*)
			echo "unknown argument: $arg" >&2
			exit 2
			;;
	esac
done

setup_osx() {
	# shellcheck source=/dev/null
	source "$REPO_ROOT/.macos"

	if ! command -v brew &>/dev/null; then
		# source: https://brew.sh/
		echo "📀 Installing homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	if ! brew bundle check --no-upgrade --file "$REPO_ROOT/Brewfile" &>/dev/null; then
		echo "🥳 Installing from brewfile (missing packages only; run 'brew upgrade' to upgrade)"
		brew bundle install --no-upgrade --file "$REPO_ROOT/Brewfile"
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
			chsh -s "$(command -v zsh)"
		fi
	fi

	if [[ ! -d ~/.oh-my-zsh ]]; then
		# source: https://github.com/ohmyzsh/ohmyzsh
		echo "🖥 Installing oh my zsh"
		RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
}

link_dotfiles() {
	local src dest
	while read -r src dest; do
		case "$src" in '' | '#'*) continue ;; esac
		src="$REPO_ROOT/$src"
		dest="$HOME/$dest"
		if [[ -L "$dest" && "$(readlink "$dest")" = "$src" ]]; then
			continue
		fi
		mkdir -p "$(dirname "$dest")"
		if [[ -e "$dest" || -L "$dest" ]]; then
			echo "🪓 Moving existing ${dest/#"$HOME"/\~} to ${dest/#"$HOME"/\~}.old"
			mv "$dest" "$dest.old"
		fi
		echo "🪱 Symlinking ${dest/#"$HOME"/\~}"
		ln -s "$src" "$dest"
	done <"$REPO_ROOT/symlinks.txt"
}

install_git_hooks() {
	if command -v pre-commit &>/dev/null; then
		echo "🪝 Installing git hooks (pre-commit, commit-msg, pre-push)"
		(cd "$REPO_ROOT" && pre-commit install --install-hooks -t pre-commit -t commit-msg -t pre-push >/dev/null)
	else
		echo "⚠️  pre-commit not found; git hooks not installed (brew install pre-commit)"
	fi
}

main() {
	link_dotfiles

	if [[ ! -e ~/.untracked-gitconfig ]]; then
		echo "❌ Expected File Not Found: ~/.untracked-gitconfig (pulled in by ~/.gitconfig)"
	fi

	if [[ "$LINKS_ONLY" = 1 ]]; then
		return 0
	fi

	zsh_shell_setup
	if [[ "$(uname)" = "Darwin" ]]; then
		setup_osx
	fi
	install_git_hooks
}

main
