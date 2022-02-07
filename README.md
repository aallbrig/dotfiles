# Andrew Allbright dotfiles
Personal dotfiles. This is an upgrade from my ansible based computer setup scripts.

## Installation

Download this repo locally. Run this script. The script is intentionally idempotent so please run it multiple times 😎
```bash
./fresh.sh
```

### Privileged access setup

I didn't want to have to deal with sudo every time the script is run. Use this script to setup items that require root privileges.
```bash
./admin_setup.sh
```

### Manual steps
For now, one must import unity profiles from the source code directory. Check out `unity_profiles` folder for unity profiles to import into the unity editor.

## Uninstall
In order to uninstall these dotfiles run the following commands.
```bash
./uninstall.sh
./admin_uninstall.sh
```
