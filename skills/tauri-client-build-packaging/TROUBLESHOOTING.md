# Troubleshooting

## First Checks

Before changing scripts, collect:

- host OS and architecture
- target triple
- build command
- Tauri version
- Rust toolchain
- Go version
- Node/npm version
- sidecar output filenames
- bundle output directory
- signing identity mode: none, ad-hoc, Developer ID, or CI secret

Most failures become obvious once these are printed.

## Missing Sidecar

Symptoms:

- Tauri build fails while bundling `externalBin`.
- App launches but cannot spawn sidecar.
- Runtime error mentions sidecar command creation.

Check:

```text
Core/bin/<base>-<target-triple>[.exe]
```

Common fixes:

- Build sidecar before Tauri.
- Use the exact Tauri target triple suffix.
- Keep `externalBin` as the base path.
- On Windows, include `.exe` in produced binary.
- On universal macOS, produce or map the universal sidecar intentionally.

## Wrong Version

Symptoms:

- installer filename says one version, app UI says another
- update server sees wrong version
- Rust app reports old `CARGO_PKG_VERSION`

Fix:

1. Run version synchronization before build.
2. Confirm `package.json`, `tauri.conf.json`, `Cargo.toml`, and locale files.
3. Clean stale build artifacts if the old version persists.

## Stale Icons

Symptoms:

- installer icon differs from app icon
- Windows Add/Remove Programs shows old icon
- macOS app bundle uses old icon

Fix:

```bash
npm run tauri icon src-tauri/icons/icon_source.png
```

Then clean bundle output and rebuild if needed.

## macOS App Not Found

Symptoms:

- DMG step cannot find `.app`
- build succeeded but package script fails

Search:

```text
src-tauri/target/<target>/release/bundle/macos/<Product>.app
../target/<target>/release/bundle/macos/<Product>.app
src-tauri/target/release/bundle/macos/<Product>.app
../target/release/bundle/macos/<Product>.app
```

Print searched paths in the script. Do not guess silently.

## DMG Creation Fails

Common causes:

- no GUI session for Finder AppleScript
- mounted temp image is busy
- `support/` directory missing from copied create-dmg script
- insufficient permissions for volume icon metadata
- output DMG already exists

Fixes:

- use `--skip-jenkins` to skip Finder prettifying
- detach with retry and exponential backoff
- remove existing final DMG before generating
- use `--sandbox-safe` only when APFS is not required
- sign after compression, not before

## macOS Gatekeeper Blocks App

Cause:

- app was ad-hoc signed or unsigned
- hardened runtime/notarization policy does not match distribution goal

Fix:

- use a real Developer ID signing identity for release
- notarize DMG with `notarytool`
- staple after notarization

Ad-hoc signing is suitable for local testing only.

## Windows Dependency Fetch Fails

Symptoms:

- Git, Cargo, or npm hangs/fails
- errors mention proxy, timeout, connection refused

Check:

```powershell
Get-ChildItem Env:*proxy*
git config --get http.proxy
```

If configured proxy is unreachable, remove it for the session or override Git/Cargo proxy variables.

## NSIS Installer Missing

Check:

- Tauri bundle targets include NSIS.
- Windows build is running on a compatible Windows/MSVC environment.
- `target\release\bundle\nsis\` exists.
- build did not fail before bundle phase.

If only `.msi` or another format exists, update the post-processing script to detect the actual configured bundle format.

## Publishing Finds No Artifacts

Ensure publishing scripts search:

- `.dmg`
- `.exe`
- `.msi`
- `.AppImage`
- `.deb`

Exclude temporary files:

- `rw.*`
- dotfiles

Prefer explicit version in artifact names so publish scripts can filter by release.
