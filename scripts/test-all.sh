#!/bin/sh
# Run all validation tests

set -e

echo "🚀 Running all dotfile validation tests..."
echo "=========================================="
echo ""

FAILED=0

# Run each test script
for test_script in scripts/test-*.sh; do
    # Skip test-all.sh to avoid recursion
    if [ "$test_script" = "scripts/test-all.sh" ]; then
        continue
    fi
    
    if [ -f "$test_script" ]; then
        if sh "$test_script"; then
            echo ""
        else
            FAILED=1
            echo ""
        fi
    fi
done

echo "=========================================="
if [ $FAILED -eq 0 ]; then
    echo "✅ All validation tests passed!"
    exit 0
else
    echo "❌ Some tests failed."
    exit 1
fi
