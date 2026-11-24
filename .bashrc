# shellcheck shell=bash
# .bashrc - interactive bash configuration
# Mirrors .zshrc so bash can be used as the primary shell.
# Environment variables and PATH live in ~/.profile (loaded via ~/.bash_profile);
# shared aliases/functions live in ~/.aliases and ~/.functions.

# Only configure interactive shells
case $- in
    *i*) ;;
    *) return ;;
esac

# Non-login interactive shells (e.g. `bash` from zsh) haven't read ~/.profile
# shellcheck source=/dev/null
if [ -z "$NVM_DIR" ] && [ -f ~/.profile ]; then . ~/.profile; fi
# shellcheck source=/dev/null
[ -f ~/.aliases ] && . ~/.aliases
# shellcheck source=/dev/null
[ -f ~/.functions ] && . ~/.functions

alias source-bashrc='source ~/.bashrc'
alias sbrc=source-bashrc
alias edit-bashrc='vim ~/.bashrc'
alias ebrc=edit-bashrc

# --- Shell options & history ---
shopt -s histappend checkwinsize cdspell autocd globstar 2>/dev/null
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
case "$PROMPT_COMMAND" in
    *"history -a"*) ;; # already set (e.g. re-sourcing .bashrc)
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# macOS: silence the "default shell is now zsh" notice
export BASH_SILENCE_DEPRECATION_WARNING=1

# --- <3 tmux ---
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
    if command -v tmux >/dev/null 2>&1 && [ -t 0 ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
    fi
fi

# ssh-add run without arguments adds in default public keys
[ -n "$SSH_AUTH_SOCK" ] && ssh-add -q 2>/dev/null

# --- Runtimes ---
# NVM_DIR is set in ~/.profile
mkdir -p "${NVM_DIR:-$HOME/.nvm}"
# shellcheck source=/dev/null
[ -s /opt/homebrew/opt/nvm/nvm.sh ] && . /opt/homebrew/opt/nvm/nvm.sh
# shellcheck source=/dev/null
[ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ] && . /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm

if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - bash)"
fi
if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME"/.local/bin/mise activate bash)"
fi

# --- Completion ---
# bash-completion@2 (brew) also loads everything in $(brew --prefix)/etc/bash_completion.d
# (gh, kubectl, helm, docker, task, git, brew, poetry, ruff, ...).
BREW_PREFIX=/opt/homebrew
[ -d "$BREW_PREFIX" ] || BREW_PREFIX=/usr/local
if [ -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
    # shellcheck source=/dev/null
    . "$BREW_PREFIX/etc/profile.d/bash_completion.sh"
elif [ -r /usr/share/bash-completion/bash_completion ]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
fi

# Tools that generate their own completion scripts. Output is cached in
# ~/.cache/bash-completion and regenerated only when missing or older than
# the tool binary (some generators take ~0.5s each). Writes are atomic and a
# failed generator never replaces a good cache, so a broken file can't stick.
_BASH_COMPLETION_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completion"
mkdir -p "$_BASH_COMPLETION_CACHE"
_source_completion() { # usage: _source_completion <command> <generator args...>
    local name=$1 bin out
    shift
    bin=$(command -v "$name") || return 0
    out="$_BASH_COMPLETION_CACHE/$name.bash"
    if [ ! -s "$out" ] || [ "$bin" -nt "$out" ]; then
        if SHELL=bash "$@" >|"$out.tmp.$$" 2>/dev/null && [ -s "$out.tmp.$$" ]; then
            mv -f "$out.tmp.$$" "$out"
        else
            rm -f "$out.tmp.$$"
        fi
    fi
    # shellcheck source=/dev/null
    [ -s "$out" ] && . "$out"
}
_source_completion kubectl kubectl completion bash
_source_completion uv uv generate-shell-completion bash
_source_completion uvx uvx --generate-shell-completion bash
_source_completion k9s k9s completion bash
_source_completion goreleaser goreleaser completion bash
_source_completion syft syft completion bash
_source_completion stripe stripe completion --shell bash --write-to-stdout
_source_completion opencode opencode completion
_source_completion npm npm completion
unset -f _source_completion
unset _BASH_COMPLETION_CACHE

# Alias completions
complete -o default -F __start_kubectl k 2>/dev/null
if declare -F __git_complete >/dev/null 2>&1; then __git_complete g __git_main; fi
command -v aws_completer >/dev/null 2>&1 && complete -C "$(command -v aws_completer)" aws
command -v terraform >/dev/null 2>&1 && complete -o nospace -C "$(command -v terraform)" terraform tf

# --- Prompt (git-aware) ---
if [ -r "$BREW_PREFIX/etc/bash_completion.d/git-prompt.sh" ]; then
    # shellcheck source=/dev/null
    . "$BREW_PREFIX/etc/bash_completion.d/git-prompt.sh"
fi
if declare -F __git_ps1 >/dev/null 2>&1; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    PS1='\[\e[36m\]\W\[\e[33m\]$(__git_ps1 " (%s)")\[\e[0m\] λ '
else
    PS1='\[\e[36m\]\W\[\e[0m\] λ '
fi
unset BREW_PREFIX

# peon-ping quick controls
alias peon='bash $HOME/.claude/hooks/peon-ping/peon.sh'
# shellcheck source=/dev/null
[ -f "$HOME/.claude/hooks/peon-ping/completions.bash" ] && . "$HOME/.claude/hooks/peon-ping/completions.bash"

# shellcheck source=/dev/null
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
