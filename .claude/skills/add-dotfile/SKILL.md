---
name: add-dotfile
description: Add a config file that gets symlinked into $HOME (a new dotfile, ~/.config/* file, or ~/bin script). Use when tracking a new config or script in this repo.
---

# Add a dotfile

1. Put the file in the repo at the path that mirrors its purpose: top-level for `~/.<name>`, `bin/` for `~/bin` scripts, a folder for nested targets (e.g. `ssh/config`).
2. Add one line to `symlinks.txt`: `<repo path>  <path relative to $HOME>`. `install.sh`, `uninstall.sh` and `scripts/check-symlinks.sh` all read it, so this is the only registration.
3. Give the file a gate in `.pre-commit-config.yaml` that **parses or loads it with its own tool** (the pattern used by `ssh-config`, `gitconfig`, `tmux-conf`, `vimrc`). For shell files, add the path to the `shellcheck`/`shfmt` `files:` regex and the matching `*-syntax` hook. Use a `check-jsonschema` hook when a JSON Schema exists for the format (look in the check-jsonschema builtin list first, then schemastore.org).
4. If the file holds machine-specific values, move those into an untracked include (see AGENTS.md).
5. Link it on this machine: `./install.sh --links-only`.

Done when `sh scripts/check-symlinks.sh` reports all in sync and `task ci` is green with the new gate actually running against the file (it appears as Passed, not "no files to check").
