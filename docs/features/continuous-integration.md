---
title: Continuous integration
nav_group: Features
nav_order: 3
---

# Continuous integration

The template ships a CI workflow that runs the checks a Go project needs,
with the knobs already set: least-privilege permissions, pinned actions, and
canceled superseded pull-request runs. You edit code and CI covers the rest.

## What runs on every push and pull request

The `.github/workflows/ci.yml` `checks` job:

- validates `cmd/VERSION` and `CHANGELOG.md` formats through
  `scripts/check-release-files.sh`
- runs the release-notes extraction test, `sh scripts/release-notes_test.sh`
- fails if `gofmt -l .` lists any file, with instructions in the message
- runs `go vet ./...`
- runs `make vulncheck`, so a newly disclosed vulnerability blocks merge
  before it ships

## Cross-platform builds

The `build` job tests and compiles on `ubuntu-latest`, `windows-latest`, and
`macos-latest`. The matrix fails fast, so a Linux-only regression cannot
reach a release on Windows.

Go builds against the version pinned in `go.mod` by
`actions/setup-go` with `go-version-file: go.mod`, with module caching on,
so CI and local development use the same toolchain.

## Weekly vulnerability report

`.github/workflows/govulncheck.yml` runs `make vulncheck` on a Monday
schedule and on pull requests. A scheduled failure means a new advisory
reaches a dependency (or the standard library version) in this project. Fix
by bumping the dependency in `go.mod`, not by silencing the tool.

## Security posture of the workflow itself

- every action is pinned to a commit SHA, not to a mutable tag
- workflow permissions start at `contents: read`; only the tagging and
  release jobs broaden to `contents: write`
- a concurrency group cancels superseded pull-request runs, but never
  cancels runs on `main`

## Related files

- `.github/workflows/ci.yml` - checks, build matrix, release pipeline
- `.github/workflows/govulncheck.yml` - scheduled and pull-request scans
- `Makefile` - `vulncheck`, `test`, and `vet` targets used by CI
