#!/usr/bin/env bash
# Remove the dotfile symlinks listed in symlinks.txt (only if they still
# point into this repo). Restores <file>.old backups made by install.sh.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

tilde() { if [[ "$1" == "$HOME"/* ]]; then echo "~${1#"$HOME"}"; else echo "$1"; fi; }

echo "🦉 Uninstall script"

while read -r src dest; do
    case "$src" in '' | '#'*) continue ;; esac
    src="$REPO_ROOT/$src"
    dest="$HOME/$dest"
    if [[ -L "$dest" && "$dest" -ef "$src" ]]; then
        echo "🪓 Deleting $(tilde "$dest")"
        rm "$dest"
        if [[ -e "$dest.old" ]]; then
            echo "♻️  Restoring $(tilde "$dest").old"
            mv "$dest.old" "$dest"
        fi
    fi
done <"$REPO_ROOT/symlinks.txt"

if [[ -e "$HOME/.untracked-gitconfig" ]]; then
    echo "❌ it is up to the user to delete ~/.untracked-gitconfig"
fi
echo "❌ it is up to the user to remove oh-my-zsh, ~/.ssh and the homebrew installation"
