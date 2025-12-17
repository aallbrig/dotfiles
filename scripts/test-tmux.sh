#!/bin/sh
# Test .tmux.conf validity

set -e

echo "🧪 Testing .tmux.conf validity..."
echo ""

# Check if tmux is installed
if ! command -v tmux >/dev/null 2>&1; then
    echo "⚠️  tmux is not installed - skipping .tmux.conf validation"
    exit 0
fi

echo "✅ tmux is installed"
echo ""

# Check if .tmux.conf exists
if [ ! -f ".tmux.conf" ]; then
    echo "⚠️  .tmux.conf not found"
    exit 0
fi

# Validate .tmux.conf syntax
echo "📋 Validating .tmux.conf..."
# Test by starting a server in the background and sourcing the config
if tmux -f .tmux.conf start-server \; kill-server >/dev/null 2>&1; then
    echo "   ✅ .tmux.conf syntax is valid"
else
    echo "   ❌ .tmux.conf has syntax errors"
    tmux -f .tmux.conf start-server \; kill-server
    exit 1
fi

echo ""
echo "✅ .tmux.conf validation passed!"
exit 0
