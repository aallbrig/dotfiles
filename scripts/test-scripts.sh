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

# Scripts to check
SCRIPTS="install.sh uninstall.sh"

FAILED=0
for script in $SCRIPTS; do
    if [ ! -f "$script" ]; then
        echo "⚠️  File not found: $script"
        continue
    fi
    
    echo "📋 Checking $script..."
    
    # Basic syntax check
    if sh -n "$script" 2>/dev/null; then
        echo "   ✅ Syntax check passed"
    else
        echo "   ❌ Syntax errors found"
        sh -n "$script"
        FAILED=1
    fi
    
    # Shellcheck if available
    if [ $SHELLCHECK_AVAILABLE -eq 1 ]; then
        if shellcheck --severity=warning "$script"; then
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
