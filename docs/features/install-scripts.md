---
title: One-line install scripts
---

# One-line install scripts

The template ships installers, so the first published
[release](automatic-releases.md) can be installed by end users without
installing Go. The scripts run on Linux, macOS, and Windows.

## Usage

On Linux or macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/sahithyandev/go-cli-template/main/scripts/install.sh | sh
```

On Windows, in PowerShell:

```powershell
powershell -c "irm https://raw.githubusercontent.com/sahithyandev/go-cli-template/main/scripts/install.ps1 | iex"
```

Both connect to the GitHub API, find the latest release for the host OS and
architecture, download the matching archive, and install the binary.

## What the POSIX script does

`scripts/install.sh`:

- maps `uname -s` and `uname -m` to goreleaser's OS and arch names and exits
  with a message on unsupported combinations
- compares the installed binary's `version` output with the latest release
  and reports up to date instead of reloading the same release
- installs to `/usr/local/bin` when it is writable, falls back to
  `~/.local/bin`, and says when the chosen directory is missing from `PATH`
- on a zsh login shell, links shell completions into `~/.zshrc` once

## What the Windows script does

`scripts/install.ps1` installs the latest `windows_amd64` zip into the local
app data directory and points out the `PATH` entry to add.

## Renaming when adapting

Both scripts hardcode the repo slug and binary name at the top, with a comment
marking the spot. When a project renames those two values, the installers
keep working with no other change. See
[Template features](index.md) for the full rename checklist.

## Related files

- `scripts/install.sh` - POSIX installer
- `scripts/install.ps1` - Windows installer
- `.goreleaser.yaml` - the archive names the scripts download
