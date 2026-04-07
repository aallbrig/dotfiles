#!/bin/sh
# Check if dotfile symlinks are in sync with the repository.
# Reports missing, broken, or wrong-target symlinks and suggests
# running install.sh to fix them.
#
# NOTE: The expected symlinks list below must be kept in sync with
# install.sh and uninstall.sh when symlinks are added or removed.

set -e

# Resolve the repository root (parent of the scripts/ directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Expected symlinks: "target_path:source_path" (target is in $HOME, source is in repo)
EXPECTED_SYMLINKS="
$HOME/.profile:$REPO_ROOT/.profile
$HOME/.aliases:$REPO_ROOT/.aliases
$HOME/.functions:$REPO_ROOT/.functions
$HOME/.zshrc:$REPO_ROOT/.zshrc
$HOME/.gitconfig:$REPO_ROOT/.gitconfig
$HOME/.tmux.conf:$REPO_ROOT/.tmux.conf
$HOME/.ssh/config:$REPO_ROOT/ssh/config
$HOME/.vimrc:$REPO_ROOT/.vimrc
$HOME/.ideavimrc:$REPO_ROOT/.ideavimrc
"

OUT_OF_SYNC=0
TOTAL=0

for entry in $EXPECTED_SYMLINKS; do
    # Skip empty lines
    [ -z "$entry" ] && continue

    target=$(echo "$entry" | cut -d: -f1)
    source=$(echo "$entry" | cut -d: -f2-)
    name=$(basename "$target")
    TOTAL=$((TOTAL + 1))

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        echo "❌ $name — missing ($target does not exist)"
        OUT_OF_SYNC=$((OUT_OF_SYNC + 1))
    elif [ ! -L "$target" ]; then
        echo "⚠️  $name — exists but is not a symlink ($target)"
        OUT_OF_SYNC=$((OUT_OF_SYNC + 1))
    else
        actual=$(readlink "$target")
        if [ "$actual" != "$source" ]; then
            echo "🔗 $name — wrong target (points to $actual, expected $source)"
            OUT_OF_SYNC=$((OUT_OF_SYNC + 1))
        else
            echo "✅ $name"
        fi
    fi
done

echo ""
if [ "$OUT_OF_SYNC" -eq 0 ]; then
    echo "✅ All $TOTAL symlinks are in sync."
    exit 0
else
    echo "⚠️  $OUT_OF_SYNC of $TOTAL symlinks out of sync — run ./install.sh to fix."
    exit 1
fi
