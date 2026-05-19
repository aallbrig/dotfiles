#!/bin/sh
# Test .tmux.conf validity

set -e

echo "🧪 Testing .tmux.conf validity..."
echo ""

if ! command -v tmux >/dev/null 2>&1; then
    echo "⚠️  tmux is not installed - skipping .tmux.conf validation"
    exit 0
fi

echo "✅ tmux is installed"
echo ""

if [ ! -f ".tmux.conf" ]; then
    echo "⚠️  .tmux.conf not found"
    exit 0
fi

echo "📋 Validating .tmux.conf..."
# Use a named socket so this never touches an active tmux session
TMUX_SOCKET="dotfiles-validate"
if output=$(tmux -L "$TMUX_SOCKET" -f .tmux.conf start-server \; kill-server 2>&1); then
    echo "   ✅ .tmux.conf syntax is valid"
else
    echo "   ❌ .tmux.conf has syntax errors"
    printf '%s\n' "$output"
    tmux -L "$TMUX_SOCKET" kill-server 2>/dev/null || true
    exit 1
fi

echo ""
echo "✅ .tmux.conf validation passed!"
exit 0
