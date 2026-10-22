# go-cli-template

a template repository for new Go command-line tools. Fork or "Use this
template", rename a few files, and you get the whole skeleton for free:

- a [Cobra](https://github.com/spf13/cobra) CLI with a `version` command and an
  example `greet` command to copy flags and argument handling from
- versioned git hooks: a pre-commit hook that checks release file formats and
  re-stages gofmt-formatted `.go` files
- CI: gofmt, `go vet`, govulncheck, and a test and build matrix over Linux,
  macOS, and Windows
- an automatic release pipeline driven by two small files (`cmd/VERSION` and
  `CHANGELOG.md`): no manual tagging, goreleaser builds and publishes
  Linux/macOS/Windows archives, checksums, and a CycloneDX SBOM
- one-line install scripts for users (`scripts/install.sh`,
  `scripts/install.ps1`)
- a Jekyll docs site deployed to GitHub Pages

## Use it

1. Create your repository from this template, then clone it.
2. Rename the references:

   | What | Where |
   | --- | --- |
   | module path | `go.mod` and the imports in `main.go` / tests |
   | binary name | `Makefile` (`BIN`), `cmd/root.go` (`Use`), `.goreleaser.yaml` (`project_name` / `binary`) |
   | repo slug | install scripts under `scripts/`, `SECURITY.md`, `.goreleaser.yaml` release config, GitHub remote |
   | docs title | `docs/_config.yml`, `docs/index.md` |
   | agent guidance | `AGENTS.md` and this README (examples that use `app`, including this list) |

3. Delete the example `greet` command (`cmd/greet.go`, its test, and the
   registration in `cmd/root.go`) once real commands exist.
4. Run `make hooks` after the first clone so the pre-commit hook is active.

## Usage

Build and play with the example commands:

```sh
make build   # compiles ./bin/app
make run     # go run .
./bin/app version
./bin/app greet --caps world
```

## Development

### Prerequisites

- Go 1.26+
- GNU Make
- Python not required; the docs site needs Ruby/Jekyll only when editing docs

### Setup

After cloning, run `make hooks` to install the versioned pre-commit hook. It:

- checks `cmd/VERSION` and `CHANGELOG.md` formats (using
  [`scripts/check-release-files.sh`](scripts/check-release-files.sh))
- formats staged `.go` files with `gofmt` and re-stages them

### Dependencies

| Name                                          | Description                                             |
| --------------------------------------------- | ------------------------------------------------------- |
| [spf13/cobra](https://github.com/spf13/cobra) | CLI framework (commands, flags, help/usage)             |
| spf13/pflag                                   | transitive dep of Cobra, POSIX-style flags              |
| inconshreveable/mousetrap                     | transitive dep of Cobra, Windows double-click detection |

`golang.org/x/sys` in `go.mod` is already listed as a direct dependency in the
template; drop it if you don't need syscall access.

### Commands

```sh
make build     # compile ./bin/app
make run       # go run .
make test      # run tests
make vet       # static checks
make fmt       # gofmt all files
make vulncheck # scan deps and Go stdlib for known vulnerabilities
```

Run a single test: `go test ./path/to/package -run TestName`.

CI runs `make vulncheck` (govulncheck) on pull requests and every Monday. A
failing scheduled run means a new advisory affects a dependency or the Go
version in `go.mod`; bump it to fix.

Version is read from `cmd/VERSION` and embedded into the binary at compile
time (`app version`).

### Releasing

Releases are driven by `cmd/VERSION`. Never push tags by hand.

The template ships `cmd/VERSION` as `0.0.0` and no matching `## 0.0.0`
section in `CHANGELOG.md`, so nothing releases on the first pushes to `main`.
Bump the version and rename a `## Unreleased` section to it when you want to
cut the first release.

1. Rename `## Unreleased` in `CHANGELOG.md` to `## <version>`, matching
   `cmd/VERSION`.
2. Bump `cmd/VERSION` if needed.
3. Merge to `main`. CI tags `v<version>` and runs goreleaser, using that
   changelog section as the release notes.

Every push to `main` releases `cmd/VERSION` if it isn't released yet, whether
or not the file changed in that push. If `CHANGELOG.md` has no non-empty
section for the version, or the tag already exists, CI skips the release and
says so in a run annotation.

`cmd/VERSION` must be a single `MAJOR.MINOR.PATCH` line, and `CHANGELOG.md`
must start with `## Unreleased` followed by unique `## <version>` headings.
The pre-commit hook and the first CI step both enforce this.

If the release fails after the tag is created, CI deletes the tag so the next
push to `main` retries. Any GitHub release goreleaser already created is
deleted too.

Check the notes extraction locally with `sh scripts/release-notes_test.sh`.
Don't run goreleaser locally to release.

#### Versioning

[SemVer](https://semver.org) (`MAJOR.MINOR.PATCH`). While `MAJOR` is `0`,
nothing is API-stable yet, so any bump can contain a breaking change. Once
something external depends on your behavior staying put, cut `1.0.0` and start
honoring MAJOR for breaks, MINOR for features, PATCH for fixes.

#### Writing the changelog

Everything lands under `## Unreleased` as it's written. One bullet per
user-visible change: what changed and why it matters to someone running the
tool. List commits elsewhere. Skip anything with no user-visible effect
(refactors, test-only changes, CI tweaks that don't change release behavior).

A few rules to keep entries consistent:

- Write in the present tense, describing what the tool does now, not what
  changed ("`clear` restores the-original-values.json", not "fixed `clear` to
  restore...").
- Start each bullet with the affected command or area when it's not obvious
  from context.
- Reference flags, commands, and paths with backticks.
- One idea per bullet.

Releasing renames that section to the version, per the steps above; a fresh
`## Unreleased` section starts accumulating the next round of changes
immediately after.

## Docs site

The `docs/` directory is a Jekyll site. `make docs` serves it locally; CI
deploys every change under `docs/` to GitHub Pages. Read
`docs/index.md` before adding pages.
