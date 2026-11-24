#!/bin/sh
# Start interactive zsh and bash login shells and fail if either writes
# anything unexpected to stderr (e.g. a tool's init command breaking after an
# upgrade). Also reports startup time and warns above a budget.
#
# Env:
#   STARTUP_BUDGET_SECS  warn threshold per shell (default 1.5)
#   STARTUP_STRICT=1     treat a budget overrun as a failure

BUDGET="${STARTUP_BUDGET_SECS:-1.5}"
STATUS=0

# stderr lines that are expected noise rather than config errors
IGNORE='Identity added:|^logout$|no job control in this shell|cannot set terminal process group|Inappropriate ioctl for device|^$'

now() { perl -MTime::HiRes=time -e 'printf "%.3f\n", time'; }

check_shell() {
    label=$1
    shift
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "⚠️  $label: $1 not installed, skipping"
        return 0
    fi
    errfile=$(mktemp)
    start=$(now)
    # TMUX set so the rc files don't exec tmux; stdin closed so nothing waits for input
    TMUX=startup-test "$@" </dev/null >/dev/null 2>"$errfile"
    end=$(now)
    elapsed=$(echo "$end - $start" | bc | sed 's/^\./0./')
    unexpected=$(grep -vE "$IGNORE" "$errfile")
    rm -f "$errfile"

    if [ -n "$unexpected" ]; then
        echo "❌ $label wrote to stderr on startup (${elapsed}s):"
        echo "$unexpected" | sed 's/^/     /'
        STATUS=1
    elif [ "$(echo "$elapsed > $BUDGET" | bc)" -eq 1 ]; then
        echo "🐢 $label started cleanly but took ${elapsed}s (budget ${BUDGET}s)"
        [ "${STARTUP_STRICT:-0}" = 1 ] && STATUS=1
    else
        echo "✅ $label started cleanly in ${elapsed}s"
    fi
}

echo "🧪 Testing interactive shell startup..."
check_shell "zsh (interactive)" zsh -i -c exit
check_shell "bash (login, interactive)" bash -l -i -c exit
exit "$STATUS"
