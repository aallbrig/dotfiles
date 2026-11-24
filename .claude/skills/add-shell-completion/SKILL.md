---
name: add-shell-completion
description: Add tab completion for a CLI tool in zsh and bash. Use when a command lacks completion or a tool's completion broke after an upgrade.
---

# Add shell completion

## 1. Check whether it already completes

- zsh: `TMUX=x zsh -ic 'echo ${_comps[TOOL]:-NONE}' </dev/null`
- bash: `TMUX=x bash -lic 'complete -p TOOL' </dev/null`

Homebrew installs many completions into `$(brew --prefix)/share/zsh/site-functions` and `etc/bash_completion.d`, and both shells already load those. If the tool completes in both shells, stop here.

## 2. Find its generator

Try `TOOL completion zsh`, `TOOL completion --help` and `TOOL --help | grep -i complet`. Note what the zsh output **starts with**:

- `#compdef TOOL`: a native zsh completer.
- A bash-style script (uses `complete`/`compdef` calls, e.g. yargs `###-begin-...`): it has to be sourced.

## 3. Register it in both rc files, cached

Generators can take 0.5s, so completions are cached and only regenerated when the tool binary is newer than the cache:

- `.zshrc`, native completer: add `_cache_completion TOOL <generator args>` **above** `source $ZSH/oh-my-zsh.sh`. It writes into an fpath directory before compinit runs.
- `.zshrc`, bash-style script: add `_source_cached_completion TOOL <generator args>` in the "Zsh autocompletion" block (after `bashcompinit`).
- `.bashrc`: add `_source_completion TOOL <generator args>` in the Completion block. It sets `SHELL=bash` for generators that detect the shell.

For an alias of the tool in bash, add `complete -F <function> ALIAS`. zsh completes aliases as their target automatically.

Done when step 1 shows a completer in **both** shells and `task test-startup` passes within its time budget.
