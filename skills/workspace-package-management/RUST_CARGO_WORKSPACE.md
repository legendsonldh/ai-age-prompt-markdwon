# Rust Cargo Workspace

## Purpose

Use a root Cargo workspace to coordinate Rust crates and centralize versions that must stay aligned.

Typical Tauri shape:

```toml
[workspace]
resolver = "2"
members = [
    "client/src-tauri",
]

[workspace.dependencies]
tauri = { version = "2.2.0", features = [] }
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
```

## Resolver

Use:

```toml
resolver = "2"
```

This gives better feature resolution for modern Rust workspaces.

## Dependency Centralization

Put dependencies in `[workspace.dependencies]` when:

- multiple crates use the same dependency
- Tauri plugin versions must align
- upgrade risk should be reviewed once
- feature sets should be consistent

Keep dependencies local when:

- only one crate uses them
- feature needs are unique
- centralization would obscure ownership

Member crate:

```toml
[dependencies]
tauri = { workspace = true, features = ["tray-icon"] }
serde = { workspace = true }
image = { version = "0.24", features = ["png"] }
```

## Feature Policy

Workspace dependency features are a baseline. Member crates can add features where needed:

```toml
tauri = { workspace = true, features = ["tray-icon", "image-png"] }
```

Avoid enabling broad features globally unless all members need them.

## Lockfile

Keep one `Cargo.lock` at the workspace root for applications.

Rules:

- Commit `Cargo.lock` for binaries/apps.
- Review lockfile changes after dependency updates.
- Do not delete `Cargo.lock` to fix version conflicts unless explicitly approved.

## Commands

Check one package:

```bash
cargo check -p package-name
```

Inspect dependency graph:

```bash
cargo tree -p package-name
```

Update one dependency:

```bash
cargo update -p dependency-name
```

## Tauri Notes

For Tauri apps:

- Keep Tauri core and plugin versions aligned.
- Keep `tauri-build` in `[build-dependencies]` via workspace when possible.
- Verify `src-tauri/Cargo.toml` package version is synchronized with app metadata.
- Feature mismatches often show up as compile errors in generated Tauri code.
