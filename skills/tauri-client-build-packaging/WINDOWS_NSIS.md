# Windows NSIS Packaging

## Build Shape

The reliable Windows path is:

1. Diagnose proxy settings that may break Git or Cargo.
2. Optionally synchronize version.
3. Build the Windows sidecar explicitly.
4. Regenerate icons.
5. Install frontend dependencies.
6. Run Tauri build.
7. Rename the NSIS installer with version and platform.

## Proxy Diagnostics

Windows build failures often come from stale proxy configuration. Check:

- `HTTP_PROXY`
- `HTTPS_PROXY`
- `http_proxy`
- `https_proxy`
- `git config --get http.proxy`

If a proxy is configured but unreachable, remove it for the current session:

```powershell
Remove-Item Env:\HTTP_PROXY
Remove-Item Env:\HTTPS_PROXY
```

For Git/Cargo, force proxy bypass in the current process when needed:

```powershell
$env:GIT_CONFIG_PARAMETERS = "'http.proxy=' 'https.proxy='"
$env:CARGO_HTTP_PROXY = ""
$env:CARGO_HTTPS_PROXY = ""
```

This avoids confusing network failures during dependency fetches.

## Sidecar Build

Build Windows sidecar with explicit environment:

```powershell
$env:GOARCH = "amd64"
$env:GOOS = "windows"
$env:CGO_ENABLED = "0"

go build `
  -tags "release" `
  -trimpath `
  -ldflags "-X 'Core/constant.Version=$VersionStr' -X 'Core/constant.BuildTime=$BuildTime' -w -s" `
  -o bin/cosmos-submarine-core-x86_64-pc-windows-msvc.exe `
  ./cmd/sidecar
```

The important output convention is:

```text
<sidecar-base>-x86_64-pc-windows-msvc.exe
```

The Tauri `externalBin` config should point to the sidecar base path, not the suffixed `.exe`.

## Icons

Regenerate icons before final build:

```powershell
Push-Location Submarine-Client
npm run tauri icon src-tauri/icons/icon_source.png
Pop-Location
```

This prevents stale installer icons, especially after replacing source assets.

## Tauri Build

Run dependency install before build:

```powershell
Push-Location Submarine-Client
npm install
npm run tauri build
Pop-Location
```

Tauri should produce bundle output under:

```text
target\release\bundle\
```

NSIS installers commonly land under:

```text
target\release\bundle\nsis\
```

## Installer Naming

Rename the installer after Tauri build:

```powershell
$Version = "v2.4.4"
$Platform = "x86_64"
$NewName = "Product_${Version}_${Platform}.exe"
```

Before moving:

- If the destination already exists, delete it.
- If the file is already correctly named, skip it.
- Print old and new names for operator confidence.

## Output Summary

At the end, print:

- sidecar binary path
- Tauri bundle directory
- NSIS installer path

Operators should not have to hunt through target folders after a successful build.

## Common Failures

- `cargo` cannot fetch crates: stale proxy or unreachable proxy.
- sidecar spawn fails at runtime: sidecar was not built with the expected target suffix.
- wrong installer icon: icon regeneration did not run or stale bundle cache remains.
- version mismatch: `package.json`, `tauri.conf.json`, `Cargo.toml`, or displayed UI version was not synchronized.
- installer not found: Tauri changed output path or NSIS target was disabled.
