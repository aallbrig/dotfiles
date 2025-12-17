#!/bin/sh
# Test Brewfile validity

set -e

echo "🧪 Testing Brewfile validity..."
echo ""

# Check if brew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "⚠️  brew is not installed - skipping Brewfile validation"
    exit 0
fi

echo "✅ brew is installed"
echo ""

# Check if Brewfile exists
if [ ! -f "Brewfile" ]; then
    echo "⚠️  Brewfile not found"
    exit 0
fi

# Validate Brewfile syntax
echo "📋 Validating Brewfile syntax..."
if brew bundle check --file=Brewfile --no-upgrade >/dev/null 2>&1; then
    echo "   ✅ Brewfile syntax is valid (all packages installed)"
else
    # Check if it's a syntax error or just missing packages
    if brew bundle list --file=Brewfile >/dev/null 2>&1; then
        echo "   ✅ Brewfile syntax is valid"
        echo "   ℹ️  Some packages may not be installed (non-fatal)"
    else
        echo "   ❌ Brewfile has syntax errors"
        brew bundle list --file=Brewfile
        exit 1
    fi
fi

echo ""
echo "✅ Brewfile validation passed!"
exit 0
