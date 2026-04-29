# pnpm/npm Workspace

## Purpose

Use pnpm workspaces to coordinate multiple frontend apps, docs sites, and Tauri web UIs from one repository root.

Example:

```yaml
packages:
  - "client"
  - "frontend"
  - "docs"
```

## Root package.json

The root `package.json` should be private and mostly orchestration-focused:

```json
{
  "private": true,
  "scripts": {
    "install:all": "pnpm install",
    "dev:client": "pnpm --filter client dev",
    "dev:frontend": "pnpm --filter frontend dev",
    "build:client": "pnpm --filter client build",
    "build:frontend": "pnpm --filter frontend build",
    "build:all": "pnpm -r build"
  },
  "engines": {
    "node": ">=18.0.0",
    "pnpm": ">=8.0.0"
  }
}
```

Do not put app-only dependencies in the root package unless the root actually runs code that needs them.

## Package Names

Each workspace package should have a stable `name`.

Use that name with filters:

```bash
pnpm --filter package-name dev
pnpm --filter package-name build
pnpm --filter package-name lint
```

Avoid relying on directory paths in scripts when package names are available.

## Adding Dependencies

Add runtime dependency to one package:

```bash
pnpm --filter package-name add dependency
```

Add dev dependency:

```bash
pnpm --filter package-name add -D dependency
```

Add root-only tooling only with explicit intent:

```bash
pnpm add -Dw dependency
```

## Lockfiles

Use one `pnpm-lock.yaml` at the repository root.

Rules:

- Commit lockfile changes with package changes.
- Do not introduce `package-lock.json` or `yarn.lock` into pnpm repos.
- If a subproject already has a package-lock, remove it only with approval and migration intent.

## Build Scripts

Root scripts should be short and composable:

- `dev:*`
- `build:*`
- `lint:*`
- `test:*`
- `clean`

Prefer:

```bash
pnpm --filter package-name build
```

over:

```bash
cd package-name && npm run build
```

unless a script must run from a specific directory for toolchain reasons.

## Tauri Frontend Notes

For Tauri apps:

- frontend package owns Vite/React dependencies
- `src-tauri` owns Rust dependencies
- root scripts can call frontend package scripts
- sidecar build scripts may live at root if they orchestrate Go + Rust + Node together

Keep the boundary clear: Node packages should not manage Rust dependencies.
