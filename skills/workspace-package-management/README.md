# Workspace Package Management

Reusable Skill and references for managing polyglot monorepo package workspaces across Go, Rust, and Node.

## Documents

- [SKILL.md](SKILL.md): Agent-facing entry point and workflow.
- [GO_WORKSPACE.md](GO_WORKSPACE.md): Go `go.work`, multi-module ownership, and validation.
- [RUST_CARGO_WORKSPACE.md](RUST_CARGO_WORKSPACE.md): Cargo workspace membership, shared dependencies, features, and lockfiles.
- [PNPM_NPM_WORKSPACE.md](PNPM_NPM_WORKSPACE.md): pnpm workspace membership, root scripts, filters, and dependency ownership.
- [CROSS_ECOSYSTEM_POLICY.md](CROSS_ECOSYSTEM_POLICY.md): Shared rules for lockfiles, toolchains, CI, and orchestration.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): Common workspace and lockfile failures.

## Intended Use

Use this series when a repository combines:

- Go services or sidecars
- Rust/Tauri crates
- React/Vite frontends
- docs sites or auxiliary Node packages
- root-level build and release scripts

The goal is to keep each ecosystem idiomatic while still making the monorepo easy to operate from the root.
