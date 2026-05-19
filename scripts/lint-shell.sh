#!/bin/sh
# Shellcheck all shell scripts in the repo (used by CI and `task lint`)
set -e

echo "🔍 Shellchecking all shell scripts..."
find . -name '*.sh' -not -path './.git/*' -print0 | xargs -0 shellcheck --severity=style
echo "✅ All shell scripts passed shellcheck"
