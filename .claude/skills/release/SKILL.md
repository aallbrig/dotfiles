---
name: release
description: Cut a dotfiles release via release-please.
disable-model-invocation: true
---

# Release

Merging to `main` makes release-please open or update a PR titled `chore(main): release X.Y.Z`. That PR holds the version bump in `version.txt` / `.release-please-manifest.json` and the generated `CHANGELOG.md`. Merging it creates tag `vX.Y.Z` and a GitHub Release. Versions follow semver from commit types: `feat` gives a minor bump, `fix`/`perf` a patch, and `!` or `BREAKING CHANGE:` a major.

1. `gh pr list --search "chore(main): release"` to find the release PR. Review its CHANGELOG. To fix a changelog entry, edit the commit message upstream: amend before merging, or use a `Release-As:`/fixup commit. The changelog itself is regenerated, so hand edits to `CHANGELOG.md` are overwritten.
2. The human merges the release PR.
3. After the **first** release ships, delete `"release-as": "1.0.0"` from `release-please-config.json` in a `chore:` commit. Otherwise every later release stays pinned to 1.0.0.

If no release PR appears, check that repo Settings → Actions → General → "Allow GitHub Actions to create and approve pull requests" is enabled, then re-run the Release Please workflow.

Done when `gh release view` shows the new tag and the changelog matches the merged commits.
