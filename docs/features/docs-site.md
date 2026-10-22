---
title: Jekyll docs site
---

# Jekyll docs site

The `docs/` directory is a [Jekyll](https://jekyllrb.com) site deployed to
GitHub Pages. Documentation is reviewed and merged with code, and the
deployment is automatic.

## Writing

Pages are plain Markdown with a small front matter block. This page, for
example, starts with:

```yaml
---
title: Jekyll docs site
---
```

Jekyll wraps the Markdown with `docs/_layouts/default.html` and serves the
result at the Pages URL. No build step beyond the workflow's bundle install.

## Previewing locally

```sh
make docs
```

That installs the gems in the bundled `Gemfile.lock` and serves the site with
livereload at `http://localhost:4000`. Dependencies are locked, so previews
match what CI builds.

## Deployment

`.github/workflows/pages.yml` runs the Ruby setup, builds the site, and calls
`deploy-pages` on every push to `main` that changes anything under `docs/`.
The workflow declares `pages: write` and `id-token: write`, the permissions
GitHub Pages deployments require, and nothing more.

Pages must be enabled once in the repository settings, with the build source
set to GitHub Actions; the workflow then keeps the site current on its own.

## Serving one page per feature

An overview with links out to one page per feature keeps single-subject
pages searchable and readable on their own. Keep prose short on the index
and deep in the feature pages, and cross-link between the two levels.
This [features section](index.md) is an example of the pattern.

## Related files

- `docs/index.md` - the site home page
- `docs/_config.yml` - site title and default layout
- `docs/_layouts/` and `docs/assets/` - presentation
- `.github/workflows/pages.yml` - build and deploy workflow
