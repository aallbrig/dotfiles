#!/bin/sh
# Test .gitconfig validity

set -e

echo "🧪 Testing .gitconfig validity..."
echo ""

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "⚠️  git is not installed - skipping .gitconfig validation"
    exit 0
fi

echo "✅ git is installed"
echo ""

# Check if .gitconfig exists
if [ ! -f ".gitconfig" ]; then
    echo "⚠️  .gitconfig not found"
    exit 0
fi

# Validate .gitconfig syntax
echo "📋 Validating .gitconfig..."
if git config --file .gitconfig --list >/dev/null 2>&1; then
    echo "   ✅ .gitconfig syntax is valid"
else
    echo "   ❌ .gitconfig has syntax errors"
    git config --file .gitconfig --list
    exit 1
fi

echo ""
echo "✅ .gitconfig validation passed!"
exit 0
