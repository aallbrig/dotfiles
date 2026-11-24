#!/bin/sh
# Shellcheck only shell scripts staged for commit (used by `task precommit`)
set -e

echo "🔍 Shellchecking staged shell scripts..."
staged=$(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$' || true)
if [ -z "$staged" ]; then
    echo "No shell scripts staged — skipping shellcheck"
    exit 0
fi
while IFS= read -r file; do
    shellcheck --severity=style "$file"
done <<EOF
$staged
EOF
echo "✅ Staged shell scripts passed shellcheck"
