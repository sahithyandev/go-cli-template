---
title: CLI project layout
nav_group: Features
nav_order: 7
---

# CLI project layout

The template's `cmd/` package is a working Cobra CLI, small enough to read in
one sitting and structured the way a real project grows.

## What exists on day one

- `main.go` calls `cmd.Execute()` and nothing else
- `cmd/root.go` defines the root command, the `version` command, and the
  command registration
- `cmd/greet.go` is an example command demonstrating flags, positional
  arguments, output to `OutOrStdout`, and `RunE` for error returns
- `internal/binutil` is an example internal package with tests: bounds-safe
  reads of integers, bitfields, and fixed-width strings, used by any tool
  that parses binary formats
- `cmd/greet_test.go` shows the expected test style, table-driven, over
  out-compared text

The binary reports its version from a compile-time embedded `cmd/VERSION`
file, so the CLI and the [release pipeline]({% link features/automatic-releases.md %}) share one
source of truth.

## Adding a command

1. Create `cmd/<name>.go`, following `greet`: the constructor builds the
   command, `init()` in `cmd/root.go` registers it
2. Flags belong to the command file; declare them next to the command
3. Return errors from `RunE` instead of calling `os.Exit` inside commands
4. Remove `greet` and its test once a real first command exists

When a command file grows past one screen, the template's pattern is to move
the reusable logic to an `internal/` package and keep `cmd/` as glue. That
keeps the Cobra layer thin and internal logic testable without parsing.

## Where to grow next

The `internal/` directory is where domain logic goes. `binutil` demonstrates
the house style: exported helpers are small, return errors instead of
panicking, and their tests use known byte sequences and boundary sizes. New
packages follow the same rules, and each gets its own directory.

## Related files

- `cmd/root.go`, `cmd/greet.go`, `cmd/greet_test.go`
- `cmd/VERSION` - embedded version string
- `internal/binutil/` - internal-package example and its doc.go
- `Makefile` - `build`, `run`, and `test` targets
