#!/bin/sh
# Validate ssh client config files: ssh must parse them, and no Host pattern
# may be declared twice (ssh silently uses the first match, so a duplicate
# block is dead config).
status=0
for f in "$@"; do
    if ! ssh -G -F "$f" example.invalid >/dev/null 2>&1; then
        echo "❌ $f: ssh cannot parse this config"
        ssh -G -F "$f" example.invalid 2>&1 >/dev/null | head -5
        status=1
    fi
    dups=$(awk 'tolower($1) == "host" { for (i = 2; i <= NF; i++) print $i }' "$f" | sort | uniq -d)
    if [ -n "$dups" ]; then
        echo "❌ $f: duplicate Host pattern(s): $dups"
        status=1
    fi
done
exit "$status"
