# Go Workspace

## Purpose

Use `go.work` to coordinate multiple Go modules in one repository without forcing them into one module.

Good fit:

- independent backend services
- command-line helpers
- native sidecars
- shared internal modules during local development

## Membership

Example:

```go
go 1.24.0

use (
    ./Core
    ./server
    ./tools/helper
)
```

Add a module with:

```bash
go work use ./path/to/module
```

Do not hand-edit `go.work` when the command can do it safely.

## Module Ownership

Each `go.mod` should own its direct dependencies.

Use the workspace to make local modules visible together, not to hide missing requirements.

Rules:

- Run `go mod tidy` inside the module that changed.
- Keep module names stable.
- Avoid importing across modules via relative paths.
- Prefer meaningful module names even for internal tools.

## Version Differences

Different modules can have different `go` versions, but avoid unnecessary drift.

If one module upgrades Go because a dependency requires it:

1. Check whether other modules also need the upgrade.
2. Update CI/build images if needed.
3. Run tests in each affected module.
4. Commit `go.mod` and `go.sum` changes together.

## Validation

From each changed module:

```bash
go test ./...
go mod tidy
```

From repository root:

```bash
go work sync
```

Use `go work sync` carefully; it can update module dependency versions. Review the diff after running it.

## Common Problems

- Build works locally but fails in CI: CI did not use `go.work` or checked out only one module.
- Dependency appears unused: it belongs in another module's `go.mod`.
- Import path mismatch: module name and import path drifted.
- Unexpected version upgrade: `go work sync` or another module pulled a newer transitive version.
