#!/bin/sh
# Test .bashrc validity

set -e

echo "🧪 Testing .bashrc validity..."
echo ""

# Check if bash is installed
if ! command -v bash >/dev/null 2>&1; then
    echo "⚠️  bash is not installed - skipping .bashrc validation"
    exit 0
fi

echo "✅ bash is installed"
echo ""

# Check if .bashrc exists
if [ ! -f ".bashrc" ]; then
    echo "⚠️  .bashrc not found"
    exit 0
fi

# Validate .bashrc syntax
echo "📋 Validating .bashrc syntax..."
if bash -n .bashrc && bash -n .bash_profile 2>/dev/null; then
    echo "   ✅ .bashrc syntax check passed"
else
    echo "   ❌ .bashrc has syntax errors"
    bash -n .bashrc && bash -n .bash_profile
    exit 1
fi

# Check with shellcheck if available
if command -v shellcheck >/dev/null 2>&1; then
    echo "📋 Running shellcheck on .bashrc..."
    if shellcheck --shell=bash --severity=style .bashrc .bash_profile; then
        echo "   ✅ shellcheck passed"
    else
        echo "   ❌ shellcheck found issues"
        exit 1
    fi
fi

echo ""
echo "✅ .bashrc validation passed!"
exit 0
