#!/bin/sh
# Syntax-check POSIX shell files with every POSIX shell available
# (dash is the strictest; sh is bash-in-posix-mode on macOS).
status=0
for f in "$@"; do
    for sh in dash sh; do
        command -v "$sh" >/dev/null 2>&1 || continue
        if ! "$sh" -n "$f"; then
            echo "❌ $f: $sh -n failed"
            status=1
        fi
    done
done
exit "$status"
