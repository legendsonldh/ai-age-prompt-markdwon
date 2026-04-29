# Cross Ecosystem Policy

## Boundary Rules

A polyglot monorepo should have clear ownership boundaries:

- Go modules own Go dependencies and `go.sum`.
- Rust crates own Cargo dependencies and `Cargo.lock`.
- Node packages own package dependencies and `pnpm-lock.yaml`.
- Root scripts orchestrate; they should not hide ownership.

## Change Types

### Local Dependency Change

Only one package/module needs a dependency.

Do:

- add it inside that package/module
- update only that ecosystem's lockfile
- run targeted verification

Do not:

- add it to root
- centralize it in workspace config prematurely

### Shared Dependency Change

Multiple packages need the same dependency/version.

Do:

- centralize only if the ecosystem supports it cleanly
- document why the version is shared
- run every affected package

Examples:

- Rust Tauri plugin versions in `[workspace.dependencies]`
- root pnpm dev tooling used by multiple packages

### Build Orchestration Change

Root scripts, CI, or release scripts change.

Do:

- inspect all workspace membership files
- keep commands package-manager-native
- update docs if operator workflow changes
- run root-level verification

## Lockfile Policy

Commit lockfiles with dependency changes:

- `go.sum`
- `Cargo.lock`
- `pnpm-lock.yaml`

Review lockfile diffs for:

- unexpected major upgrades
- duplicated dependency versions
- new transitive packages with native bindings
- registry/source changes

## Clean Policy

Clean commands are useful but risky.

Prefer explicit commands:

```bash
pnpm -r exec rm -rf node_modules
rm -rf target
```

Do not run destructive cleanups while unrelated user changes are present unless the user approves.

## Version Policy

Keep toolchain versions visible:

- `go` directive in `go.work` and `go.mod`
- Rust edition and workspace resolver
- Node/pnpm engines

If upgrading a toolchain:

1. Update config.
2. Update CI/build images.
3. Regenerate lockfiles through package-manager commands.
4. Run builds/tests for affected packages.

## CI Strategy

Good CI jobs mirror workspace boundaries:

- Go modules: `go test ./...` per module or workspace-aware job.
- Rust workspace: `cargo check --workspace` or package-specific checks.
- Node workspace: `pnpm install --frozen-lockfile`, then filtered builds.
- Release jobs: call root orchestration scripts.

## Documentation Rule

Whenever a root script becomes the recommended way to run a task, document:

- what it builds
- which package manager it uses
- where output artifacts land
- whether it mutates versions or lockfiles
