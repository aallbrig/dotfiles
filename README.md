# Andrew Allbright dotfiles
Personal dotfiles. This is an upgrade from my ansible based computer setup scripts.

## Installation

Download this repo locally. Run this script. The script is intentionally idempotent so please run it multiple times 😎
```bash
./install.sh
```

### Manual steps
For now, one must import unity profiles from the source code directory. Check out `unity_profiles` folder for unity profiles to import into the unity editor.

## File Structure

This repository uses a shell-agnostic approach for portability:

- **`.profile`** - POSIX-compliant environment variables (PATH, EDITOR, etc.)
- **`.aliases`** - POSIX-compliant aliases (works in sh, bash, zsh, dash)
- **`.zshrc`** - Zsh-specific configuration (sources `.profile` and `.aliases`)
- Other dotfiles: `.gitconfig`, `.tmux.conf`, `.vimrc`, etc.

## Testing

To ensure POSIX compliance of `.profile` and `.aliases`:

```bash
# Install shellcheck (if not already installed)
brew install shellcheck  # macOS
# or
sudo apt install shellcheck  # Ubuntu/Debian

# Run POSIX compliance tests
./test-posix.sh
```

Tests are also run automatically via GitHub Actions on push/PR.

## Uninstall
In order to uninstall these dotfiles run the following commands.
```bash
./uninstall.sh
```
