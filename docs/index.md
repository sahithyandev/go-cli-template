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

## Documentation

As the project grows, give each command its own short Markdown page here and
link it below. The GitHub Pages workflow deploys every change under `docs/`.

## Editing these pages

Pages are plain Markdown rendered by Jekyll. Keep the tone of the repo:
short sentences, no filler, examples over adjectives.
