#!/bin/sh
# Fail if any given file hard-codes a user's home directory (/Users/<name> or
# /home/<name>). Use $HOME or ~ instead so dotfiles work for any user/machine.
# Allow a deliberate occurrence by putting "allow-hardcoded-home" on the line.
status=0
for f in "$@"; do
    if grep -nE '/(Users|home)/[A-Za-z0-9._-]+' "$f" |
        grep -vE '/(Users|home)/\$\{?USER|allow-hardcoded-home' >/dev/null; then
        grep -nE '/(Users|home)/[A-Za-z0-9._-]+' "$f" |
            grep -vE '/(Users|home)/\$\{?USER|allow-hardcoded-home' |
            sed "s|^|$f:|"
        status=1
    fi
done
[ "$status" -eq 0 ] || echo "❌ Hard-coded home paths found; use \$HOME or ~ instead." >&2
exit "$status"
