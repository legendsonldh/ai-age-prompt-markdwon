---
name: tauri-client-build-packaging
description: Design, debug, and maintain Tauri desktop client build scripts for macOS and Windows, including Go/Rust sidecar binaries, version synchronization, icon regeneration, Tauri bundle targets, DMG creation, NSIS installers, code signing, and release artifact naming.
---

# Tauri Client Build Packaging

## When To Use

Use this skill when working on Tauri desktop client build, packaging, or release scripts.

Trigger scenarios:

- Building macOS `.app` or `.dmg` installers.
- Building Windows NSIS `.exe` installers.
- Adding or debugging sidecar binaries.
- Cross-building macOS Intel, macOS Apple Silicon, universal macOS, or Windows x64 targets.
- Synchronizing versions across `package.json`, `tauri.conf.json`, `Cargo.toml`, and localized UI strings.
- Regenerating app icons before packaging.
- Handling code signing, ad-hoc signing, notarization, or installer naming.
- Debugging missing sidecar binaries, wrong bundle output paths, stale icons, failed DMG layout, or broken Windows proxy/Cargo/Git networking.

## Core Principles

- Treat the build as a pipeline, not a single `tauri build` command.
- Build sidecars before the Tauri bundle so `externalBin` can resolve platform-specific binaries.
- Keep version updates deterministic and apply them before building.
- Regenerate icons before packaging when icon source or metadata changes.
- On macOS, build `.app` first, then create the DMG manually when Tauri's default bundler is not reliable enough.
- On Windows, build the sidecar with explicit `GOOS=windows`, `GOARCH=amd64`, `CGO_ENABLED=0`, then let Tauri produce NSIS output.
- Never hardcode real certificates, passwords, private keys, tokens, or notarization credentials in reusable scripts or docs.

## Reference Files

Read these before editing build logic:

- [PIPELINE.md](PIPELINE.md)
- [MACOS_DMG.md](MACOS_DMG.md)
- [WINDOWS_NSIS.md](WINDOWS_NSIS.md)
- [SIDECAR_AND_VERSIONING.md](SIDECAR_AND_VERSIONING.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- [REFERENCE_SCRIPTS.md](REFERENCE_SCRIPTS.md)

## Recommended Workflow

1. Identify the target platform: native, macOS Intel, macOS Apple Silicon, macOS universal, or Windows x64.
2. Validate prerequisites: Go, Rust/Cargo, Node/npm, Tauri CLI, platform SDKs, and any signing identities.
3. Clean only when needed; prefer explicit `--clean` or `-c` to avoid slow rebuilds.
4. Synchronize version if a release version is provided.
5. Build sidecar binaries for the same target triples Tauri expects.
6. Install frontend dependencies and run the frontend build.
7. Regenerate icons before bundle creation when icon assets may have changed.
8. Run Tauri build with platform-appropriate bundle targets.
9. Post-process artifacts: sign, DMG, rename, and verify output paths.
10. Publish only after confirming artifact names, platform tags, and release notes.

## Canonical Commands

macOS native build with DMG:

```bash
./build.sh --version v2.4.4
```

macOS universal build:

```bash
./build.sh --version v2.4.4 --targets universal-apple-darwin
```

macOS build without DMG bundling:

```bash
./build.sh --version v2.4.4 --no-bundle
```

macOS signed build:

```bash
./build.sh --version v2.4.4 --codesign "Developer ID Application: Example Team"
```

Windows PowerShell build:

```powershell
.\build.ps1 -v v2.4.4
```

Forced clean build:

```bash
./build.sh --clean --version v2.4.4
```

```powershell
.\build.ps1 -c -v v2.4.4
```

## Verification Checklist

- Sidecar binary exists under the expected `Core/bin` target name.
- Tauri `externalBin` points to the sidecar base name, not a platform-specific suffix.
- `package.json`, `tauri.conf.json`, `Cargo.toml`, and visible version strings agree.
- Icons were regenerated from the source icon before final bundling.
- macOS `.app` exists before DMG creation.
- macOS DMG excludes temporary `rw.*` files.
- Windows NSIS installer is renamed with version and platform.
- No credentials or private tokens were committed.

## Reference Scripts

When implementing or repairing a real build pipeline, inspect these concrete scripts:

- [reference-scripts/build.sh](reference-scripts/build.sh)
- [reference-scripts/build.ps1](reference-scripts/build.ps1)

Treat them as working examples to adapt, not generic boilerplate. Preserve their sequencing unless the target project has a clear reason to change it.
