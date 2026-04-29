---
name: workspace-package-management
description: Manage polyglot monorepo dependencies and workspace scripts across Go workspaces, Rust Cargo workspaces, and npm/pnpm workspaces. Use when adding packages, aligning versions, editing go.work, Cargo.toml workspace dependencies, pnpm-workspace.yaml, root package scripts, lockfiles, or build orchestration.
---

# Workspace Package Management

## When To Use

Use this skill when working in a monorepo that combines multiple package ecosystems:

- Go modules coordinated by `go.work`.
- Rust crates coordinated by a root Cargo workspace.
- Node apps coordinated by npm/pnpm workspaces.
- Tauri apps that bridge Rust and frontend packages.
- Build scripts that need stable root-level commands.

Trigger scenarios:

- Adding a new Go module, Rust crate, frontend app, docs site, or package.
- Updating shared Rust dependencies in `[workspace.dependencies]`.
- Adding npm dependencies to one workspace package without polluting others.
- Updating root scripts such as `dev:*`, `build:*`, `lint:*`, or `test:*`.
- Resolving lockfile drift across `go.sum`, `Cargo.lock`, and `pnpm-lock.yaml`.
- Debugging a build that works in a subfolder but fails from the monorepo root.

## Core Principles

- Treat each ecosystem as independent, but expose root-level orchestration commands.
- Use workspace files for membership, not as dumping grounds for unrelated config.
- Keep dependency ownership local unless multiple members genuinely share the same version.
- Prefer package-manager commands over hand-editing lockfiles.
- Validate from both the package directory and the monorepo root.
- Do not mix package managers accidentally: if the repo uses pnpm, do not introduce npm/yarn lockfiles.

## Reference Files

Read the focused reference before changing workspace/package configuration:

- [GO_WORKSPACE.md](GO_WORKSPACE.md)
- [RUST_CARGO_WORKSPACE.md](RUST_CARGO_WORKSPACE.md)
- [PNPM_NPM_WORKSPACE.md](PNPM_NPM_WORKSPACE.md)
- [CROSS_ECOSYSTEM_POLICY.md](CROSS_ECOSYSTEM_POLICY.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Recommended Workflow

1. Identify which ecosystem owns the change: Go, Rust, Node, or cross-ecosystem build orchestration.
2. Inspect workspace membership files before editing:
   - `go.work`
   - root `Cargo.toml`
   - `pnpm-workspace.yaml`
   - root `package.json`
3. Add dependencies using the correct package manager command from the correct directory.
4. Update root scripts only when a command is useful across the monorepo.
5. Run targeted verification for the changed package.
6. Run root-level verification if workspace membership or shared versions changed.
7. Commit workspace config and lockfiles together.

## Command Defaults

Go:

```bash
go work use ./path/to/module
go test ./...
go mod tidy
```

Rust:

```bash
cargo check -p package-name
cargo update -p dependency-name
cargo tree -p package-name
```

pnpm:

```bash
pnpm --filter package-name add dependency
pnpm --filter package-name add -D dependency
pnpm --filter package-name build
pnpm -r build
```

## Non-Negotiables

- Do not manually edit generated lockfile sections unless there is no package-manager alternative.
- Do not add unused packages at the root just because one workspace member needs them.
- Do not centralize every dependency; centralize only high-value shared versions.
- Do not delete lockfiles during troubleshooting unless explicitly approved.
- Do not run broad clean commands without checking for unrelated user changes.
- Do not commit credentials in package manager config files such as `.npmrc`.
