# Sidecar And Versioning

## Why This Matters

Tauri desktop apps often wrap a native helper process. The build system must keep three things aligned:

- the native sidecar binary name
- Tauri `externalBin` target resolution
- release version metadata across frontend, Rust, native sidecar, and visible UI

Most packaging bugs come from these surfaces drifting apart.

## Sidecar Naming Contract

Configure Tauri with a base path:

```json
{
  "bundle": {
    "externalBin": [
      "../../Core/bin/cosmos-submarine-core"
    ]
  }
}
```

Then produce target-suffixed binaries:

| Platform | Expected binary |
| --- | --- |
| macOS Intel | `cosmos-submarine-core-x86_64-apple-darwin` |
| macOS Apple Silicon | `cosmos-submarine-core-aarch64-apple-darwin` |
| macOS universal | `cosmos-submarine-core-universal-apple-darwin` |
| Windows x64 | `cosmos-submarine-core-x86_64-pc-windows-msvc.exe` |
| Linux x64 | `cosmos-submarine-core-x86_64-unknown-linux-gnu` |
| Linux ARM64 | `cosmos-submarine-core-aarch64-unknown-linux-gnu` |

Do not point `externalBin` directly at a platform-suffixed file.

## Go Build Flags

Use release tags, trim paths, strip symbols, and inject version/build time:

```bash
CGO_ENABLED=0 go build \
  -tags "release" \
  -trimpath \
  -ldflags "-X 'Core/constant.Version=${VERSION}' -X 'Core/constant.BuildTime=${BUILD_TIME}' -w -s -buildid=" \
  -o "bin/<sidecar-name>" \
  ./cmd/sidecar
```

Use `CGO_ENABLED=0` when the sidecar does not need CGO. It improves portability and reduces runtime dependency surprises.

## Universal macOS Sidecar

Build both architectures first:

```bash
make sidecar-darwin-amd64 TAGS=release
make sidecar-darwin-arm64 TAGS=release
```

Then combine:

```bash
lipo -create \
  bin/cosmos-submarine-core-x86_64-apple-darwin \
  bin/cosmos-submarine-core-aarch64-apple-darwin \
  -output bin/cosmos-submarine-core-universal-apple-darwin
```

Verify:

```bash
lipo -info bin/cosmos-submarine-core-universal-apple-darwin
```

## Version Synchronization

A release version should update all of these:

- frontend `package.json`
- `src-tauri/tauri.conf.json`
- `src-tauri/Cargo.toml`
- localized UI version strings

Recommended behavior:

- input accepts `v2.4.4` or `2.4.4`
- machine metadata stores `2.4.4`
- UI display can store `v2.4.4`

Pseudo-flow:

```js
const cleanVersion = version.replace(/^v/, '');
const displayVersion = `v${cleanVersion}`;

packageJson.version = cleanVersion;
tauriConfig.version = cleanVersion;
cargoToml.package.version = cleanVersion;
locale.dashboard.footer.version = displayVersion;
```

## Build-Time Version In Sidecar

If the sidecar exposes diagnostics or version info, inject:

- release version
- short git hash
- build timestamp

Example:

```powershell
$GitHash = git rev-parse --short HEAD
$BuildTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$VersionStr = "$VersionArg-$GitHash"
```

## Release Artifact Version

Use the display version in artifacts:

```text
Product_v2.4.4_x86_64.exe
Product_v2.4.4_aarch64.dmg
Product_v2.4.4_universal.dmg
```

Publishing scripts can then infer:

- version from filename
- platform from extension
- architecture from `aarch64`, `arm64`, `x86_64`, `amd64`, or `universal`

## Safety Rules

- Do not commit real signing identities as defaults.
- Do not commit bearer tokens, update-server passwords, or private keys.
- Do not silently publish artifacts after build; require explicit confirmation or CI approval.
- Print version and artifact paths before publishing.
