# Idea: tmuxinator port scanner

A shell function (or small script) that scans `~/src/` projects for tmuxinator files
and reports which ports are "hypothetically taken" — useful for picking free ports when
setting up a new project's dev environment.

## Motivation

Each project in `~/src/` declares port reservations in its `.tmuxinator/*.yml` header
comments (e.g. `# Port reservations: :1319 Hugo, :3005 SAM`). Without a scanner you
have to open files manually to find a free port, which breaks down as the number of
projects grows.

## Proposed interface

```
# Show ports claimed by my projects (default: filter by git user)
src-ports

# Show all ports including forks / third-party repos
src-ports --all

# Show ports for a specific project
src-ports madcatalog
```

## Implementation sketch

```bash
src-ports() {
  local filter_user="${GIT_AUTHOR_NAME:-$(git config user.name 2>/dev/null)}"
  local all=false
  local target=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all) all=true ;;
      *)     target="$1" ;;
    esac
    shift
  done

  find ~/src -maxdepth 3 -name '*.yml' -path '*/.tmuxinator/*' | sort | while read -r f; do
    project=$(basename "$(dirname "$(dirname "$f")")")

    # Filter: skip repos not owned by the user unless --all
    if ! $all && [ -z "$target" ]; then
      repo_dir="$(dirname "$(dirname "$f")")"
      remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null || echo "")
      # Heuristic: remote URL contains the user's GitHub handle
      handle=$(echo "$filter_user" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
      echo "$remote" | grep -qi "$handle" || continue
    fi

    # Filter by target project name if given
    [ -n "$target" ] && [ "$project" != "$target" ] && continue

    # Extract port numbers from "# Port reservations:" comment lines
    ports=$(grep -i 'port.*reserv' "$f" | grep -oE ':[0-9]{4,5}' | tr '\n' ' ')
    [ -n "$ports" ] && printf "%-30s %s\n" "$project" "$ports"
  done
}
```

## Notes

- The comment convention `# Port reservations: :PORT service` needs to be consistent
  across projects for the grep to work reliably. Consider standardising this in a
  `# Port reservations:` header line in all `.tmuxinator/*.yml` files.
- An alternative is parsing the tmuxinator YAML for `task X:dev` calls and then
  reading port vars from the project's `Taskfile.yml` — more robust but much more complex.
- Could live in `~/src/dotfiles/scripts/src-ports.sh` and be sourced from `~/.zshrc`.
