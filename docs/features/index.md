---
title: Template features
nav_group: Overview
nav_order: 2
---

# Template features

go-cli-template ships a working project backbone, not just a `main.go`. This
section explains each feature, what you get out of the box, and which files
implement it.

- [Automatic releases]({% link features/automatic-releases.md %}) - push to `main`, get a tagged
  GitHub release with archives, checksums, and changelog-derived notes
- [SBOM on every release]({% link features/sbom.md %}) - a CycloneDX SBOM built from `go.mod` and
  attached to each release, next to `checksums.txt`
- [Continuous integration]({% link features/continuous-integration.md %}) - gofmt, vet,
  govulncheck, and a three-OS test and build matrix on every pull request
- [Pre-commit hooks]({% link features/pre-commit-hooks.md %}) - versioned, framework-free git
  hooks that format Go code and guard release file formats
- [One-line install scripts]({% link features/install-scripts.md %}) - `curl | sh` and PowerShell
  installers that ship with your first GitHub release
- [Jekyll docs site]({% link features/docs-site.md %}) - this site, deployed to GitHub Pages on
  every change under `docs/`
- [CLI project layout]({% link features/cli-project-layout.md %}) - a Cobra skeleton with an
  embedded version, an example command, and an example internal package

## Design choices

The template favors plain tools over frameworks: shell scripts instead of a
hook manager, Jekyll instead of a docs framework, gofmt instead of a linting
suite. Each is easy to replace when a project outgrows it, and nothing here
assumes GitHub beyond the release and Pages workflows.
