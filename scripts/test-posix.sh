#!/bin/sh
# Test POSIX compliance of shell configuration files
# Uses shellcheck for static analysis

set -e

echo "🧪 Testing POSIX compliance of dotfiles..."
echo ""

# Files to check for POSIX compliance
POSIX_FILES=".profile .aliases .functions"

# Check if shellcheck is installed
if ! command -v shellcheck >/dev/null 2>&1; then
    echo "❌ shellcheck is not installed"
    echo "   Install with: brew install shellcheck (macOS)"
    echo "              or: apt install shellcheck (Ubuntu/Debian)"
    exit 1
fi

echo "✅ shellcheck is installed"
echo ""

# Test each POSIX file
FAILED=0
for file in $POSIX_FILES; do
    if [ ! -f "$file" ]; then
        echo "⚠️  File not found: $file"
        continue
    fi
    
    echo "📋 Checking $file for POSIX compliance..."
    # Use dash shell (pure POSIX) to check for syntax errors
    if sh -n "$file" 2>/dev/null; then
        echo "   ✅ POSIX syntax check passed"
    else
        echo "   ❌ POSIX syntax errors found"
        sh -n "$file"
        FAILED=1
    fi
    
    # Use shellcheck with POSIX shell specification
    if shellcheck --shell=sh --severity=warning "$file"; then
        echo "   ✅ shellcheck passed"
    else
        echo "   ❌ shellcheck found issues"
        FAILED=1
    fi
    echo ""
done

# Test that files can be sourced without errors
echo "🔄 Testing that files can be sourced..."
for file in $POSIX_FILES; do
    if [ -f "$file" ]; then
        if sh -c ". ./$file" >/dev/null 2>&1; then
            echo "   ✅ $file sources successfully"
        else
            echo "   ❌ $file failed to source"
            FAILED=1
        fi
    fi
done

echo ""
if [ $FAILED -eq 0 ]; then
    echo "✅ All POSIX compliance tests passed!"
    exit 0
else
    echo "❌ Some tests failed. Please fix the issues above."
    exit 1
fi
