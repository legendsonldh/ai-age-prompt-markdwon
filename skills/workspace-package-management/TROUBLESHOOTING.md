# Troubleshooting

## Root Build Fails But Package Build Works

Check:

- package is included in workspace membership
- root script uses the correct package name
- command requires a specific working directory
- environment variables differ between root and package scripts

For pnpm:

```bash
pnpm --filter package-name build
```

## Package Not Found By pnpm Filter

Check:

- `pnpm-workspace.yaml` includes the directory
- package `name` is correct
- package is not private in a way that affects publishing only, not filtering

List packages:

```bash
pnpm -r list --depth -1
```

## Cargo Feature Conflict

Check:

- workspace dependency features
- member-level feature additions
- duplicate dependency versions

Use:

```bash
cargo tree -p package-name
cargo tree -d
```

## Cargo Package Cannot See Workspace Dependency

Check:

- root `Cargo.toml` has `[workspace.dependencies]`
- member crate uses `{ workspace = true }`
- dependency is in the correct section: `[dependencies]` vs `[build-dependencies]`

## Go Module Uses Wrong Local Dependency

Check:

- `go.work` includes the local module
- import path matches module path
- `go env GOWORK`
- CI uses the same workspace context

Use:

```bash
go env GOWORK
go list -m all
```

## Lockfile Changed Too Much

Common causes:

- package manager version changed
- broad update command was used
- root install touched all packages
- dependency range allowed a newer version

Fix:

- identify intended package changes
- rerun targeted package-manager command
- review lockfile before committing

## Mixed Package Managers

Symptoms:

- `package-lock.json` appears in pnpm repo
- `yarn.lock` appears unexpectedly
- node_modules layout differs between machines

Fix:

- remove accidental lockfile only after confirming it is accidental
- document package manager in root README or engines
- use corepack if needed

## Workspace Membership Drift

Symptoms:

- new package is not built by root commands
- dependency install skips a package
- CI does not run tests for a new module

Fix:

- update membership file
- add root script if needed
- update CI matrix
- update skill/docs if workflow changes
