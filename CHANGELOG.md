# Changelog

## [1.0.1](https://github.com/aallbrig/dotfiles/compare/v1.0.0...v1.0.1) (2026-11-24)


### CI & Quality Gates

* treat every lint warning as an error ([#4](https://github.com/aallbrig/dotfiles/issues/4)) ([468d218](https://github.com/aallbrig/dotfiles/commit/468d2183322d01cd51ab07e5da2853cf3ca463eb))

## 1.0.0 (2026-11-24)


### Features

* **bash:** add .bashrc and .bash_profile ([83ab90a](https://github.com/aallbrig/dotfiles/commit/83ab90a44814b9ac3a4c40ef46497915c37314ae))
* **tmux:** mouse scrolling and vi copy-mode piping to pbcopy ([9a4c8b0](https://github.com/aallbrig/dotfiles/commit/9a4c8b07ed8189562287d18e3114f4bb1b3ac4d0))


### Bug Fixes

* address adversarial review findings ([f1a512f](https://github.com/aallbrig/dotfiles/commit/f1a512f01e06f16da56ec5bebc94ab39fbb068f3))
* correct ssh identities and Brewfile renames ([dca1f98](https://github.com/aallbrig/dotfiles/commit/dca1f98d8914494a5607955ac1635a6aa7b51dbc))
* **zsh:** drop broken gh copilot alias, cache tool completions, dedupe env ([4f3338b](https://github.com/aallbrig/dotfiles/commit/4f3338b97f484ccce962200e62a04e703de67201))


### Refactoring

* **install:** drive install/uninstall/check-symlinks from symlinks.txt ([9034f71](https://github.com/aallbrig/dotfiles/commit/9034f7181dcee65e6b3dc88543bbdf36636e56ca))


### CI & Quality Gates

* consolidate workflows into ci.yml with macOS smoke test ([360299e](https://github.com/aallbrig/dotfiles/commit/360299e1776f328332f813e704bb2f91591f7185))
* **hooks:** make pre-commit the single quality gate ([0646bb1](https://github.com/aallbrig/dotfiles/commit/0646bb1e8217d902598dc347fb6790e649b08b82))
* **hooks:** run shell-startup only on pre-push ([f1bc4f0](https://github.com/aallbrig/dotfiles/commit/f1bc4f0791da8a8fbaa12593485fd859a699089a))
* **release:** add release-please ([c281c92](https://github.com/aallbrig/dotfiles/commit/c281c9221624aa24cfd0dbef53ba929c41fd4910))


### Documentation

* **agents:** AGENTS.md as the single agent guide, plus project skills ([226e3b4](https://github.com/aallbrig/dotfiles/commit/226e3b4a6d0658e60382795d9fd2d7b6075125e8))
