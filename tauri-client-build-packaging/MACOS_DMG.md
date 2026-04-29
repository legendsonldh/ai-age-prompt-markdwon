# macOS DMG Packaging

## Build Shape

The reliable macOS path is:

1. Ensure Rust macOS targets are installed.
2. Build matching Go sidecars.
3. Build Tauri `.app` only.
4. Locate the `.app` across known output paths.
5. Sign the `.app`.
6. Create the DMG manually.
7. Optionally sign and notarize the DMG.

## Rust Targets

Add targets before building:

```bash
rustup target add x86_64-apple-darwin aarch64-apple-darwin
```

For target-specific builds:

```bash
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
```

## Sidecar Builds

Build sidecars before `tauri build`:

```bash
make sidecar-darwin-amd64 TAGS=release
make sidecar-darwin-arm64 TAGS=release
```

For universal builds, combine both sidecars:

```bash
lipo -create \
  bin/cosmos-submarine-core-x86_64-apple-darwin \
  bin/cosmos-submarine-core-aarch64-apple-darwin \
  -output bin/cosmos-submarine-core-universal-apple-darwin
```

## Tauri App Build

For macOS, prefer `.app` output first:

```bash
npm run tauri build -- --target aarch64-apple-darwin --bundles app
npm run tauri build -- --target x86_64-apple-darwin --bundles app
npm run tauri build -- --target universal-apple-darwin --bundles app
```

Native host build:

```bash
npm run tauri build -- --bundles app
```

## App Path Resolution

Tauri output paths can differ by version, workspace layout, and target. Search in this order:

1. `src-tauri/target/<target-triple>/release/bundle/macos/<Product>.app`
2. `../target/<target-triple>/release/bundle/macos/<Product>.app`
3. `src-tauri/target/release/bundle/macos/<Product>.app`
4. `../target/release/bundle/macos/<Product>.app`

Print every searched path when failing. It saves time during CI and remote debugging.

## Code Signing

Accept signing identity in two ways:

- CLI argument: `--codesign "<identity>"`
- Environment variable: `APPLE_SIGNING_IDENTITY`

Before using a supplied identity, verify it:

```bash
security find-identity -v -p codesigning
```

If no identity is present, ad-hoc signing can be acceptable for internal testing:

```bash
codesign --force --deep --sign - "<Product>.app"
```

For release distribution, use a real Developer ID identity.

## Manual DMG Creation

Manual DMG creation gives control over:

- volume name
- volume icon
- Finder window size and position
- app icon position
- Applications drop link
- compression format
- optional DMG signing
- optional notarization

Recommended shape:

```bash
bash scripts/bundle_dmg.sh \
  --skip-jenkins \
  --volname "Product" \
  --volicon src-tauri/icons/icon.icns \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "Product" 180 170 \
  --app-drop-link 420 170 \
  "target/release/bundle/dmg/Product_v2.4.4_aarch64.dmg" \
  "path/to/Product.app"
```

Use `--skip-jenkins` when Finder AppleScript prettifying is fragile in CI, sandboxed, or non-GUI environments.

## DMG Internals

A robust DMG script should:

- create a temporary read-write image
- attach it with `hdiutil`
- find the mounted volume defensively
- copy volume icons/background/resources
- create `/Applications` symlink
- optionally run AppleScript for layout
- fix permissions
- detach with retry for busy volumes
- compress to final format (`UDZO` by default)
- delete temporary `rw.*` images
- optionally sign and notarize the final DMG

## Notarization

If notarizing, use a keychain profile rather than embedding credentials:

```bash
xcrun notarytool submit "Product.dmg" --keychain-profile "<profile>" --wait
xcrun stapler staple "Product.dmg"
```

Never commit Apple account credentials, app-specific passwords, or private keys.

## Common Failures

- Missing `.app`: target output path changed or Tauri wrote under `src-tauri/target`.
- Sidecar not found: sidecar filename does not match Tauri target triple.
- DMG mount stuck: detach with retry and exponential sleep.
- AppleScript error `-1728`: skip Finder prettifying or add a delay before `osascript`.
- Gatekeeper warning: ad-hoc signing was used instead of Developer ID signing.
