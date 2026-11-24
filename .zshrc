# Load POSIX-compliant shell configuration
[ -f ~/.profile ] && source ~/.profile
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions

# If you come from bash you might have to change your $PATH.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lambda"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm)

# Cached completions for tools that generate their own zsh completion scripts
# but don't ship them into Homebrew's site-functions. Files are written to
# oh-my-zsh's cache completions dir (already on fpath) and only regenerated
# when missing or older than the tool's binary, keeping startup fast.
ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$ZSH/cache}"
mkdir -p "$ZSH_CACHE_DIR/completions"
_cache_completion() { # usage: _cache_completion <command> <generator args...>
  local name=$1; shift
  local bin out
  bin=$(command -v "$name") || return 0
  out="$ZSH_CACHE_DIR/completions/_$name"
  [[ -s $out && $out -nt $bin ]] || "$@" >| "$out" 2>/dev/null
}
_cache_completion uv uv generate-shell-completion zsh
_cache_completion uvx uvx --generate-shell-completion zsh
_cache_completion k9s k9s completion zsh
_cache_completion goreleaser goreleaser completion zsh
_cache_completion syft syft completion zsh
_cache_completion stripe stripe completion --shell zsh --write-to-stdout
unfunction _cache_completion

source $ZSH/oh-my-zsh.sh

# Zsh-specific configuration below
# (Environment variables, PATH and aliases are in ~/.profile and ~/.aliases)

# Generators for languages are in various
function available_generator_functions() {
  cat $HOME/.*-shellrc | grep '^\w*function gen::.*()' | sed -e 's/function //g' -e 's/() {//g'
}
alias agf='available_generator_functions'

# <3 tmux
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
	if command -v tmux &> /dev/null && [[ -t 0 ]] && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	  exec tmux
	fi
fi

# ssh-add run without arguments adds in default public keys
[ -n "$SSH_AUTH_SOCK" ] && ssh-add -q 2>/dev/null

# I have language specific rc files (e.g. ~/.git-shellrc, ~/.node-shellrc, ~/.go-shellrc) where language specific configuration (and/or generate fns shell fns) exist
# shellrc_files=$(~/.*-shellrc 2> /dev/null)
# if [ -n shellrc_files ]; then
  # for shellrc in $shellrc_files; do
    # . $shellrc
  # done
# fi

# NVM_DIR is set in ~/.profile
mkdir -p "${NVM_DIR}"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Zsh autocompletion
# oh-my-zsh has already run compinit (which picks up Homebrew's
# site-functions: gh, kubectl, helm, docker, task, brew, ...).
# bashcompinit enables bash-style `complete` for tools without zsh completers.
# Aliases (k, g, tf) complete as their targets automatically.
autoload -U +X bashcompinit && bashcompinit
command -v aws_completer >/dev/null 2>&1 && complete -C "$(command -v aws_completer)" aws
command -v terraform >/dev/null 2>&1 && complete -o nospace -C "$(command -v terraform)" terraform
# Bash-style generators (cached like the fpath ones above; sourced after bashcompinit)
_source_cached_completion() { # usage: _source_cached_completion <command> <generator args...>
  local name=$1; shift
  local bin out
  bin=$(command -v "$name") || return 0
  out="$ZSH_CACHE_DIR/completions/$name.zsh"
  [[ -s $out && $out -nt $bin ]] || SHELL=zsh "$@" >| "$out" 2>/dev/null
  source "$out"
}
_source_cached_completion opencode opencode completion
_source_cached_completion npm npm completion
unfunction _source_cached_completion

# peon-ping quick controls
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"
[ -f $HOME/.claude/hooks/peon-ping/completions.bash ] && source $HOME/.claude/hooks/peon-ping/completions.bash

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$(~/.local/bin/mise activate zsh)"
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
