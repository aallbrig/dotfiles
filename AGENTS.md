# dotfiles

Symlinked into `$HOME` by `./install.sh` from the manifest `symlinks.txt`.

## Where config goes

- `.profile`: environment and PATH. `.aliases`, `.functions`: shared by every shell. All three are **POSIX sh** (checked with `dash -n`), so use `[ ]`, `.` and `command -v`.
- `.zshrc` / `.bashrc`: interactive, shell-specific setup only. Keep the two in step: a feature added to one gets its counterpart in the other.
- Machine-specific or private values go in untracked files that the tracked ones already include: `~/.untracked-gitconfig`, `~/.profile_untracked`, `~/.functions_untracked`.
- Refer to the home directory as `$HOME` or `~` (a hook rejects `/Users/<name>`).
- Every tool init in an rc file is guarded (`command -v tool >/dev/null && …`), because a missing or upgraded tool must leave the shell starting cleanly.

## Done means `task ci` is green

`task ci` runs every gate: all pre-commit hooks plus `scripts/test-all.sh`. After touching an rc file, also run `task test-startup`: both shells start with empty stderr and stay under 1.5s.

Commits follow Conventional Commits (`feat`, `fix`, `refactor`, `ci`, `docs`, `style`, `chore`). The commit-msg hook enforces it, and release-please builds versions and `CHANGELOG.md` from it.

## Skills

- `.claude/skills/add-dotfile`: adding a file to be symlinked into `$HOME`.
- `.claude/skills/add-shell-completion`: adding tab completion for a CLI.

## Documentation files

Put them in `docs/` (for example `docs/design/` or `docs/research/`), with the filename prefixed by a UTC timestamp `YYYYMMDD_HHMMSS_UTC_`, e.g. `docs/design/20260329_150800_UTC_architecture_overview.md`.
