#!/bin/sh
# Test .vimrc validity

set -e

echo "🧪 Testing .vimrc validity..."
echo ""

# Check if vim is installed
if ! command -v vim >/dev/null 2>&1; then
    echo "⚠️  vim is not installed - skipping .vimrc validation"
    exit 0
fi

echo "✅ vim is installed"
echo ""

# Check if .vimrc exists
if [ ! -f ".vimrc" ]; then
    echo "⚠️  .vimrc not found"
    exit 0
fi

# Validate .vimrc syntax
echo "📋 Validating .vimrc..."
if vim -u .vimrc --not-a-term -c "quit" >/dev/null 2>&1; then
    echo "   ✅ .vimrc syntax is valid"
else
    echo "   ❌ .vimrc has syntax errors"
    vim -u .vimrc --not-a-term -c "quit"
    exit 1
fi

echo ""
echo "✅ .vimrc validation passed!"
exit 0
