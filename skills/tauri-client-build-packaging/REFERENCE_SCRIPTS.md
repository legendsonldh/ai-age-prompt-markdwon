# Reference Scripts

These scripts are concrete reference implementations extracted from a working Tauri desktop client release pipeline.

They are intentionally included as files, not just summarized prose, because build packaging details are fragile. When adapting them to another project, rename product-specific paths and artifact names, but preserve the pipeline structure.

## Files

- [reference-scripts/build.sh](reference-scripts/build.sh): macOS/Linux-oriented build script with sidecar builds, version synchronization, icon regeneration, Tauri target builds, macOS `.app` creation, manual DMG packaging, and optional code signing.
- [reference-scripts/build.ps1](reference-scripts/build.ps1): Windows PowerShell build script with proxy diagnostics, version synchronization, Windows sidecar build, icon regeneration, Tauri build, and NSIS installer renaming.

## How To Use

Use these scripts as implementation references for:

- argument parsing conventions
- clean build switches
- target-to-sidecar mapping
- version propagation
- platform-specific sidecar names
- icon regeneration timing
- macOS `.app` then DMG flow
- Windows proxy diagnostics
- NSIS artifact renaming
- final output summaries

Do not copy them blindly into a new project. First adapt:

- product name
- app bundle name
- Tauri client directory
- sidecar source directory
- sidecar binary base name
- target triples
- signing identity handling
- final artifact naming convention

## What Is Not Included

Publishing scripts that include real server URLs, bearer tokens, private endpoints, or deployment credentials should not be placed in this public reference Skill. Keep those as private project deployment scripts or rewrite them with placeholder environment variables before sharing.
