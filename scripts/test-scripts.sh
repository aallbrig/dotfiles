#!/bin/sh
# Test install.sh and uninstall.sh validity

set -e

echo "🧪 Testing shell scripts validity..."
echo ""

# Check if shellcheck is installed
SHELLCHECK_AVAILABLE=0
if command -v shellcheck >/dev/null 2>&1; then
    SHELLCHECK_AVAILABLE=1
    echo "✅ shellcheck is installed"
else
    echo "⚠️  shellcheck is not installed - will only run syntax checks"
fi

echo ""

FAILED=0

# Scripts to check
SCRIPTS="install.sh uninstall.sh scripts/check-symlinks.sh"

# Every manifest source must exist in the repo
while read -r src _dest; do
    case "$src" in '' | '#'*) continue ;; esac
    if [ ! -e "$src" ]; then
        echo "❌ symlinks.txt lists missing file: $src"
        FAILED=1
    fi
done <symlinks.txt

for script in $SCRIPTS; do
    if [ ! -f "$script" ]; then
        echo "⚠️  File not found: $script"
        continue
    fi

    echo "📋 Checking $script..."

    # Basic syntax check with the interpreter named in the shebang
    case "$(head -n 1 "$script")" in
        *bash*) interp=bash ;;
        *) interp='sh' ;;
    esac
    if "$interp" -n "$script" 2>/dev/null; then
        echo "   ✅ Syntax check passed"
    else
        echo "   ❌ Syntax errors found"
        "$interp" -n "$script"
        FAILED=1
    fi

    # Shellcheck if available
    if [ $SHELLCHECK_AVAILABLE -eq 1 ]; then
        if shellcheck --severity=style "$script"; then
            echo "   ✅ shellcheck passed"
        else
            echo "   ❌ shellcheck found issues"
            FAILED=1
        fi
    fi

    echo ""
done

if [ $FAILED -eq 0 ]; then
    echo "✅ All script validation tests passed!"
    exit 0
else
    echo "❌ Some tests failed. Please fix the issues above."
    exit 1
fi
