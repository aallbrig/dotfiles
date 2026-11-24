#!/bin/sh
# Test .zshrc validity

set -e

echo "🧪 Testing .zshrc validity..."
echo ""

# Check if zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "⚠️  zsh is not installed - skipping .zshrc validation"
    exit 0
fi

echo "✅ zsh is installed"
echo ""

# Check if .zshrc exists
if [ ! -f ".zshrc" ]; then
    echo "⚠️  .zshrc not found"
    exit 0
fi

# Validate .zshrc syntax
echo "📋 Validating .zshrc syntax..."
if zsh -n .zshrc 2>/dev/null; then
    echo "   ✅ .zshrc syntax check passed"
else
    echo "   ❌ .zshrc has syntax errors"
    zsh -n .zshrc
    exit 1
fi

# Check with shellcheck if available
if command -v shellcheck >/dev/null 2>&1; then
    echo "📋 Running shellcheck on .zshrc..."
    if shellcheck --shell=bash --severity=style .zshrc; then
        echo "   ✅ shellcheck passed"
    else
        echo "   ❌ shellcheck found issues"
        exit 1
    fi
fi

echo ""
echo "✅ .zshrc validation passed!"
exit 0
