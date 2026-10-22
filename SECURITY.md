# Security policy

## Supported versions

Only the latest release gets security fixes.

## Reporting a vulnerability

Please do not open a public issue for security problems.

Report privately through GitHub: go to the
[Security tab](https://github.com/sahithyandev/go-cli-template/security/advisories/new)
and choose "Report a vulnerability".

Include what you can of:

- the app version (`app version`) and your OS
- minimal steps that trigger the problem
- what you expected and what happened

You should get a reply within 7 days. Fixes are developed privately and
published with a GitHub security advisory once a release is out.

## Verifying releases

Each release ships `checksums.txt` (SHA-256) and a CycloneDX SBOM
(`sbom.cdx.json`). Check your download with:

```
sha256sum --ignore-missing -c checksums.txt
```
