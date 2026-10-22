---
title: Pre-commit hooks
nav_group: Features
nav_order: 4
---

# Pre-commit hooks

The template installs gofmt as a pre-commit hook, without a hook framework.
The hook lives in the repo, and every contributor gets the same behavior
without installing a tool.

## What the hook does

`.githooks/pre-commit` runs two checks on every commit:

- `scripts/check-release-files.sh`, which validates the `cmd/VERSION` and
  `CHANGELOG.md` formats described in [Automatic releases]({% link features/automatic-releases.md %})
- gofmt: staged `.go` files that differ from the index are formatted and
  re-staged, so the committed bytes are already formatted

Because `cmd/VERSION` and the changelog are checked at commit time, a broken
release file cannot slip through to CI unnoticed. CI runs the same script as
its first step, for commits made with the hook bypassed.

## How it is installed

Three layers make the hook effectively unavoidable:

1. `make hooks` runs `git config core.hooksPath .githooks`, documented in the
   README's setup step
2. `hooks_test.go` does the same as a side effect of `go test ./...`
3. if a hook still does not fire, CI catches the same violations and links to
   the fix

The hook directory is versioned, so the hook content is reviewed and updated
like any other source file, and it survives without a global git template.

## Why no hook framework

pre-commit frameworks pull in a tool, a config dialect, and an isolated
environment. This repo needs two shell checks, so the hook is plain `sh`. If
a project later wants more checks, appending commands to the same file keeps
one canonical hook.

## Related files

- `.githooks/pre-commit` - the hook itself
- `scripts/check-release-files.sh` - the release file validation
- `hooks_test.go` - side-effect hook installation on `go test`
- `Makefile` - the `hooks` target

See also [Continuous integration]({% link features/continuous-integration.md %}) for the same
guards enforced server-side.
