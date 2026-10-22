---
title: app
---

# app

a command-line tool built from the [go-cli-template](https://github.com/sahithyandev/go-cli-template)
project template: Go + Cobra, gofmt hooks, a goreleaser release pipeline, and a
Jekyll docs site on GitHub Pages.

## Build and run

```sh
make build   # compiles ./bin/app
make run     # go run .
./bin/app greet --caps world
```

## What the template includes

The [template feature guide](features/index.md) explains each of these in
depth, with the files that implement them:

- [Automatic releases](features/automatic-releases.md) from `cmd/VERSION` and
  `CHANGELOG.md`, with [an SBOM](features/sbom.md) attached to every release
- [Continuous integration](features/continuous-integration.md) across Linux,
  macOS, and Windows, with weekly govulncheck
- [Pre-commit hooks](features/pre-commit-hooks.md) for gofmt and release file
  checks
- [One-line install scripts](features/install-scripts.md) for end users
- A [Jekyll docs site](features/docs-site.md) on GitHub Pages
- A [CLI project layout](features/cli-project-layout.md) with an embedded
  version and an example command

## Documentation

As the project grows, give each command its own short Markdown page here and
link it below. The GitHub Pages workflow deploys every change under `docs/`.

## Editing these pages

Pages are plain Markdown rendered by Jekyll. Keep the tone of the repo:
short sentences, no filler, examples over adjectives.
