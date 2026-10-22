# AGENTS.md

Guidance for AI coding agents (and humans) working in this repository.

## What this is

go-cli-template is a template repository for new Go CLI software. Projects
created from it are Cobra-based CLIs with a small release pipeline:
`cmd/VERSION` plus `CHANGELOG.md` drive CI tagging and goreleaser publishing.

Layout:

- `main.go` - entry point, calls `cmd.Execute()`
- `cmd/` - root command plus subcommands (`version`, example `greet`)
- `internal/binutil/` - example internal package: bounds-safe endian,
  bitfield, and fixed-width string reads
- `scripts/` - release-file checks, release-notes extraction, install scripts
- `docs/` - Jekyll site deployed to GitHub Pages

## Commands

```
make build   # compile ./bin/app
make run     # go run .
make test    # run tests
make vet     # static checks
make fmt     # gofmt all files
```

Run a single test: `go test ./path/to/package -run TestName`

## Rules

- Renaming things? The binary name lives in four places: `Makefile` (`BIN`),
  `cmd/root.go` (`Use`), `.goreleaser.yaml` (`project_name` / `binary`), and
  the install scripts under `scripts/`. Keep them in sync. The module path is
  in `go.mod` and the module imports in `main.go` and tests. This file and
  the README are part of the rename too: they name the binary and the repo
  throughout, this list included.
- Never push release tags by hand. Releases happen through CI when
  `cmd/VERSION` matches a non-empty `## <version>` section in
  `CHANGELOG.md`.
- `cmd/VERSION` must be a single `MAJOR.MINOR.PATCH` line. `CHANGELOG.md`
  starts with `## Unreleased`, followed by unique `## <version>` headings.
  `sh scripts/check-release-files.sh` validates this; the pre-commit hook and
  CI both run it.
- Add a dependency only when the problem genuinely needs it. The template
  keeps the surface small: cobra and its transitive deps, `golang.org/x/sys`.
- New commands register in `cmd/root.go`'s `init()`. Follow the shape of
  `cmd/greet.go` until it is deleted, then whatever real command came after.

## Writing

Prose in this repo (README, `docs/`, comments, commit messages) is written:

- in the plainest words that work; no filler phrases
- with no em dashes
- in the present tense when describing what the tool does ("`clear` restores
  the originals", not "fixed `clear` to restore...")
- with flags, commands, and paths in backticks
- without emoji decorations or exclamation runs

## Commit messages

Short, concise, start with a lowercase letter. No conventional-commit style
prefixes (`feat: `, `fix: `). One logical change per commit.

## Before finishing

- `go build ./...`, `go vet ./...`, and `go test ./...` pass
- `gofmt -l .` prints nothing
- `sh scripts/check-release-files.sh` passes
- prose follows the writing rules above
