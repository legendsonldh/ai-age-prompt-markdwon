# Build Pipeline

## Mental Model

A production Tauri client build is a multi-language packaging pipeline:

1. Validate toolchains.
2. Optionally clean stale artifacts.
3. Synchronize version metadata.
4. Build native sidecar binaries.
5. Install frontend dependencies.
6. Regenerate icons.
7. Build the Tauri app.
8. Bundle platform installers.
9. Sign, notarize, rename, and publish artifacts.

Do not treat `tauri build` as the whole release process. It is only one step after sidecars, versions, icons, and target triples are correct.

## Toolchain Gates

Check early and fail clearly:

- Go for sidecar binaries.
- Rust/Cargo for Tauri shell.
- Node/npm for frontend build and Tauri CLI scripts.
- Platform-specific tools:
  - macOS: `rustup` targets, `lipo`, `codesign`, `hdiutil`, `SetFile`, optional `notarytool`.
  - Windows: PowerShell, MSVC Rust toolchain, NSIS through Tauri, reachable Git/Cargo networking.

## Clean Strategy

Make cleaning explicit. It is expensive but useful when stale artifacts cause wrong icons, old sidecars, or mismatched installers.

Clean targets commonly include:

- root `target/`
- Tauri `src-tauri/target/`
- frontend `dist/` or `out/`
- platform sidecars under `Core/bin/`

Use `--clean`, `-c`, or `-f`; do not silently wipe build outputs on every run.

## Version Strategy

Version updates should happen before compilation.

Normalize release input:

- Accept `v2.4.4` or `2.4.4`.
- Store clean semver (`2.4.4`) in machine metadata.
- Display `v2.4.4` in user-facing strings when the app convention expects it.

Update all version surfaces together:

- frontend `package.json`
- Tauri `tauri.conf.json`
- Rust `Cargo.toml`
- localized UI strings that display the version

## Sidecar First

For apps with a Go/Rust/native sidecar, build the sidecar before the Tauri bundle.

The important invariant is:

```text
Tauri externalBin base name + target triple suffix = existing sidecar binary
```

Example Tauri config:

```json
{
  "bundle": {
    "externalBin": [
      "../../Core/bin/cosmos-submarine-core"
    ]
  }
}
```

Tauri resolves platform-specific sidecar filenames from the base path, so scripts should produce names such as:

- `cosmos-submarine-core-x86_64-apple-darwin`
- `cosmos-submarine-core-aarch64-apple-darwin`
- `cosmos-submarine-core-x86_64-pc-windows-msvc.exe`

## Frontend And Icons

After sidecars:

1. Install dependencies.
2. Run frontend build through Tauri's `beforeBuildCommand`.
3. Regenerate icons from the source icon when icon assets may have changed.

Icon regeneration belongs before final bundle creation. Stale icon caches are common in desktop packaging.

## Bundle Strategy

macOS:

- Build `.app` with Tauri.
- For macOS targets, pass `--bundles app`.
- Build the DMG manually afterward when you need stable layout, app-drop-link control, or to avoid AppleScript/CI issues.

Windows:

- Build Windows sidecar explicitly.
- Run `npm run tauri build`.
- Let Tauri produce NSIS output.
- Rename installers after build to include version and platform.

## Target Mapping

Use explicit target-to-sidecar mapping:

| Tauri target | Sidecar make target |
| --- | --- |
| `x86_64-apple-darwin` | `sidecar-darwin-amd64` |
| `aarch64-apple-darwin` | `sidecar-darwin-arm64` |
| `universal-apple-darwin` | `sidecar-darwin-amd64` + `sidecar-darwin-arm64` + `lipo` |
| `x86_64-pc-windows-msvc` | `sidecar-windows-amd64` |
| `x86_64-unknown-linux-gnu` | `sidecar-linux-amd64` |
| `aarch64-unknown-linux-gnu` | `sidecar-linux-arm64` |

## Artifact Naming

Name final artifacts with product, version, and platform:

- `Product_v2.4.4_aarch64.dmg`
- `Product_v2.4.4_x86_64.dmg`
- `Product_v2.4.4_universal.dmg`
- `Product_v2.4.4_x86_64.exe`
This makes publishing scripts simpler and reduces operator error.
