#!/bin/sh
# Check if dotfile symlinks are in sync with the repository.
# Reports missing, broken, or wrong-target symlinks and suggests
# running install.sh to fix them.
#
# The expected list is symlinks.txt (shared with install.sh/uninstall.sh).

set -e

# Resolve the repository root (parent of the scripts/ directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

OUT_OF_SYNC=0
TOTAL=0

# Expected symlinks come from symlinks.txt: "<repo path>  <path relative to $HOME>"
while read -r src dest; do
    case "$src" in '' | '#'*) continue ;; esac
    source="$REPO_ROOT/$src"
    target="$HOME/$dest"
    name="$dest"
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
done < "$REPO_ROOT/symlinks.txt"

echo ""
if [ "$OUT_OF_SYNC" -eq 0 ]; then
    echo "✅ All $TOTAL symlinks are in sync."
    exit 0
else
    echo "⚠️  $OUT_OF_SYNC of $TOTAL symlinks out of sync — run ./install.sh to fix."
    exit 1
fi
