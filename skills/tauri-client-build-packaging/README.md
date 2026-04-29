# Tauri Client Build Packaging

Reusable Skill and references for macOS/Windows Tauri desktop client build scripts.

## Documents

- [SKILL.md](SKILL.md): Agent-facing entry point for build and packaging work.
- [PIPELINE.md](PIPELINE.md): End-to-end build pipeline and target mapping.
- [MACOS_DMG.md](MACOS_DMG.md): macOS `.app`, DMG, signing, and notarization guidance.
- [WINDOWS_NSIS.md](WINDOWS_NSIS.md): Windows sidecar, proxy diagnostics, NSIS build, and installer naming.
- [SIDECAR_AND_VERSIONING.md](SIDECAR_AND_VERSIONING.md): Sidecar naming contract and version synchronization.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): Common failures and fixes.
- [REFERENCE_SCRIPTS.md](REFERENCE_SCRIPTS.md): Working `build.sh` and `build.ps1` reference scripts.

## Use With UI Skill

Use this together with the Apple Glass UI Skill when UI changes affect:

- app icons
- Tauri window config
- bundle metadata
- version text
- installer output
- release publishing
