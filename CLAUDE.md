# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

go-cli-template is a template repository for new Go CLI software. It is a Cobra-based CLI skeleton with a release pipeline (cmd/VERSION + CHANGELOG.md driven tagging, goreleaser install scripts, SBOM), gofmt pre-commit hooks, CI (fmt/vet/govulncheck/build matrix), and a Jekyll docs site under docs/.

Layout: `main.go`, `cmd/` (root command + `version`, example `greet`), `internal/binutil` (bounds-safe endian/bitfield/string helpers).

## Commands

```
make build   # compile ./bin/app
make run     # go run .
make test    # run tests
make vet     # static checks
make fmt     # gofmt all files
```

Run a single test: `go test ./path/to/package -run TestName`

## Writing

When writing or editing prose (README, `docs/`, comments, commit messages), run `/avoid-ai-writing` and follow it. No em dashes, and drop the other AI-writing tells in comments, docs, and everything else.

## Commit messages

Short, concise, start with a lowercase letter. Strictly avoid conventional commits style prefixes (`label: `); commit casually. When in plan mode, plan for multiple commits.

This file (`CLAUDE.md`) is gitignored and must not be committed.

## Dependencies

Only add a dependency if it's already justified below — keep the dependency surface small.

| Name | Description |
| --- | --- |
| [spf13/cobra](https://github.com/spf13/cobra) | CLI framework (commands, flags, help/usage) |
| spf13/pflag | transitive dep of Cobra, POSIX-style flags |
| inconshreveable/mousetrap | transitive dep of Cobra, Windows double-click detection |
