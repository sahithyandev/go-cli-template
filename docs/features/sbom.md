---
title: SBOM on every release
nav_group: Features
nav_order: 2
---

# SBOM on every release

Every release exports a CycloneDX SBOM, a machine-readable inventory of the
software bill of materials: direct and transitive dependencies, their
versions, and their licenses. It is the artifact procurement teams and
security reviewers ask for, and the template ships it as part of the release
instead of as an afterthought.

## What the SBOM covers

The SBOM is generated with
[cyclonedx-gomod](https://github.com/CycloneDX/cyclonedx-gomod) from the
module graph:

- every dependency from `go.mod` and `go.sum`, listed by module and version
- license information resolved from go.mod metadata
- the hash of the module content, so artifacts in the SBOM can be matched to
  the module cache

The file is `sbom.cdx.json`, in CycloneDX JSON format.

## Where it appears

- `make sbom` regenerates it locally at any time
- the release workflow generates it for the tagged commit and uploads it as a
  workflow artifact
- goreleaser attaches it to the GitHub release next to the archives and
  `checksums.txt`

Because it is generated for the tagged commit, the SBOM always matches the
released [archives]({% link features/automatic-releases.md %}).

## Keep it in sync with security advice

The SBOM answers "what do we ship". The weekly
[govulncheck run]({% link features/continuous-integration.md %}) answers "what should we worry
about in that inventory". Together they give the standard supply-chain story:

1. an advisory names an affected module or standard function
2. `make vulncheck` reports whether your code reaches it
3. the fix lands in `go.mod`
4. the next release ships both the fixed binaries and an updated SBOM

## Related files

- `Makefile` - the `sbom` target pins the cyclonedx-gomod version
- `Makefile` - the `vulncheck` target pins the govulncheck version
- `.goreleaser.yaml` - `extra_files` carries the SBOM into the release
- `.github/workflows/ci.yml` - the `sbom` and `release` jobs
