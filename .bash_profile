# shellcheck shell=bash
# .bash_profile - bash login shell entry point
# macOS terminals start login shells, which read this file (not ~/.bashrc).
# Environment lives in ~/.profile; interactive config lives in ~/.bashrc.

# shellcheck source=/dev/null
[ -f ~/.profile ] && . ~/.profile

# shellcheck source=/dev/null
case $- in
    *i*) [ -f ~/.bashrc ] && . ~/.bashrc ;;
esac
