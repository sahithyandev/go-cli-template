---
title: Automatic releases
---

# Automatic releases

go-cli-template tags and publishes a release without manual steps. The
release state lives in two plain files, CI reads them, and
[goreleaser](https://goreleaser.com) does the build and publish. Nobody ever
pushes a tag by hand.

## How a release happens

1. Write changes under the `## Unreleased` heading in `CHANGELOG.md`.
2. Rename that heading to `## <version>` and set the same version in
   `cmd/VERSION`.
3. Merge to `main`.

CI on the next push to `main`:

- validates that `cmd/VERSION` is a single `MAJOR.MINOR.PATCH` line
- skips the release, with a run notice, when `CHANGELOG.md` has no matching
  non-empty section
- skips again when the tag already exists
- tags `v<version>`, pushes the tag, and runs goreleaser with the changelog
  section as the release notes
- deletes the tag and any half-created release if a later job fails, so the
  next push retries cleanly

Every push to `main` is considered, not just pushes that changed the files.
The same content always produces the same skip-or-release outcome.

## What a release contains

goreleaser builds from the tagged commit:

- archives for Linux, macOS, and Windows on `amd64` and `arm64` (no Windows
  on arm64), tarballs except a zip for Windows
- `checksums.txt` with SHA-256 sums for every archive
- the changelog section as the release body

## The two release files

`cmd/VERSION` is embedded into the binary at compile time, which is why the
`version` command and the release pipeline agree on one source.

`CHANGELOG.md` starts with `## Unreleased`, followed by unique version
headings. `scripts/check-release-files.sh` enforces both formats in the
pre-commit hook and in the first CI job, so a bad release never reaches the
tagging step.

## Related files

- `scripts/release-notes.sh` - extracts one version's notes from the changelog
- `scripts/release-notes_test.sh` - local test for the extraction
- `.goreleaser.yaml` - build matrix, archives, and release settings
- `.github/workflows/ci.yml` - the `tag`, `release`, and `untag` jobs

See [SBOM on every release](sbom.md) for the extra artifact that rides along
with each release.
