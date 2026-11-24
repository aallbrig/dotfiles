#!/usr/bin/env bash
# Remove the dotfile symlinks listed in symlinks.txt (only if they still
# point into this repo). Restores <file>.old backups made by install.sh.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🦉 Uninstall script"

while read -r src dest; do
    case "$src" in '' | '#'*) continue ;; esac
    src="$REPO_ROOT/$src"
    dest="$HOME/$dest"
    if [[ -L "$dest" && "$(readlink "$dest")" = "$src" ]]; then
        echo "🪓 Deleting ${dest/#"$HOME"/\~}"
        rm "$dest"
        if [[ -e "$dest.old" ]]; then
            echo "♻️  Restoring ${dest/#"$HOME"/\~}.old"
            mv "$dest.old" "$dest"
        fi
    fi
done <"$REPO_ROOT/symlinks.txt"

if [[ -e "$HOME/.untracked-gitconfig" ]]; then
    echo "❌ it is up to the user to delete ~/.untracked-gitconfig"
fi
echo "❌ it is up to the user to remove oh-my-zsh, ~/.ssh and the homebrew installation"
