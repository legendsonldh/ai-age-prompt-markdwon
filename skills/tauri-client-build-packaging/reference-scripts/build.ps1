# COMAC VPN Build Script (Windows PowerShell)
# 支持 --version/-v 参数进行版本同步

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "COMAC VPN Build Script (Windows PS1)" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# --- 代理检查与诊断 ---
Write-Host "[DIAGNOSTIC] Checking network proxy settings..." -ForegroundColor Gray
$ProxyVars = @("HTTP_PROXY", "HTTPS_PROXY", "http_proxy", "https_proxy")
$GitProxy = git config --get http.proxy

foreach ($var in $ProxyVars) {
    if (Test-Path "Env:\$var") {
        $proxyUrl = (Get-Item "Env:\$var").Value
        Write-Host "Found env proxy: $var = $proxyUrl" -ForegroundColor Yellow
        try {
            $uri = New-Object System.Uri($proxyUrl)
            $socket = New-Object Net.Sockets.TcpClient
            $asyncResult = $socket.BeginConnect($uri.Host, $uri.Port, $null, $null)
            $wait = $asyncResult.AsyncWaitHandle.WaitOne(1000, $false)
            if ($wait) {
                $socket.EndConnect($asyncResult)
                Write-Host "✓ Proxy $proxyUrl is reachable." -ForegroundColor Green
            }
            else {
                throw "Timeout"
            }
            $socket.Close()
        }
        catch {
            Write-Host "!" -NoNewline -ForegroundColor Red
            Write-Host " Proxy $proxyUrl is UNREACHABLE. Unsetting $var for this session..." -ForegroundColor Red
            Remove-Item "Env:\$var"
        }
    }
}

if ($GitProxy) {
    Write-Host "Found git proxy: $GitProxy" -ForegroundColor Yellow
    try {
        $uri = New-Object System.Uri($GitProxy)
        $socket = New-Object Net.Sockets.TcpClient
        $asyncResult = $socket.BeginConnect($uri.Host, $uri.Port, $null, $null)
        $wait = $asyncResult.AsyncWaitHandle.WaitOne(1000, $false)
        if ($wait) {
            $socket.EndConnect($asyncResult)
            Write-Host "✓ Git proxy is reachable." -ForegroundColor Green
        }
        else {
            throw "Timeout"
        }
        $socket.Close()
    }
    catch {
        Write-Host "!" -NoNewline -ForegroundColor Red
        Write-Host " Git proxy $GitProxy is UNREACHABLE. Forcing Git/Cargo to ignore proxy for this session..." -ForegroundColor Red
        # 强制 Git 忽略代理
        $env:GIT_CONFIG_PARAMETERS = "'http.proxy=' 'https.proxy='"
        # 强制 Cargo 忽略代理
        $env:CARGO_HTTP_PROXY = ""
        $env:CARGO_HTTPS_PROXY = ""
    }
}
# ----------------------

$VersionArg = ""
$CleanMode = $false

# 1. 解析参数
for ($i = 0; $i -lt $args.Count; $i++) {
    if ($args[$i] -eq "--version" -or $args[$i] -eq "-v") {
        $VersionArg = $args[$i + 1]
        $i++
    }
    elseif ($args[$i] -eq "--clean" -or $args[$i] -eq "-c") {
        $CleanMode = $true
    }
}

# 1.5 清理旧产物 (防止残留旧图标和名称)
if ($CleanMode) {
    Write-Host "[PRE-STEP] Cleaning old build artifacts..." -ForegroundColor Yellow
    if (Test-Path "target") { Remove-Item -Path "target" -Recurse -Force }
    if (Test-Path "Submarine-Client\src-tauri\target") { Remove-Item -Path "Submarine-Client\src-tauri\target" -Recurse -Force }
    if (Test-Path "Core\bin") { Remove-Item -Path "Core\bin\*" -Include "*.exe" -Force }
}
else {
    Write-Host "[PRE-STEP] Skipping clean (use --clean or -c to force full rebuild)." -ForegroundColor Gray
}

# 2. 版本同步
if ($VersionArg) {
    Write-Host "[STEP 1] Setting version to $VersionArg..." -ForegroundColor Blue
    node Submarine-Client\update-version.js $VersionArg
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Version synchronization failed."
        exit 1
    }
}
else {
    Write-Host "[STEP 1] Skipping version synchronization (no --version/-v provided)." -ForegroundColor Yellow
}

# 3. 编译 Go Sidecar
Write-Host "[STEP 2] Building Go sidecar binary..." -ForegroundColor Blue

# 获取 Git 信息
$GitHash = git rev-parse --short HEAD 2>$null
$BuildTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# 进入 Core 目录
Push-Location Core
if (-not (Test-Path bin)) { New-Item -ItemType Directory bin }

$env:GOARCH = "amd64"
$env:GOOS = "windows"
$env:CGO_ENABLED = "0"

$VersionStr = if ($VersionArg) { "$VersionArg-$GitHash" } else { "unknown-$GitHash" }

Write-Host "Building cosmos-submarine-core..."
go build -tags "release" -trimpath -ldflags "-X 'COMAC-ASDT-Submarine/Core/constant.Version=$VersionStr' -X 'COMAC-ASDT-Submarine/Core/constant.BuildTime=$BuildTime' -w -s" -o bin/cosmos-submarine-core-x86_64-pc-windows-msvc.exe ./cmd/sidecar

if ($LASTEXITCODE -ne 0) {
    Write-Error "Go sidecar build failed."
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "[SUCCESS] Go sidecar binary built." -ForegroundColor Green

# 3.5 重新生成图标 (确保安装包图标更新)
Write-Host "[STEP 2.5] Regenerating app icons..." -ForegroundColor Blue
Push-Location Submarine-Client
npm run tauri icon src-tauri/icons/icon_source.png
Pop-Location

# 4. 构建前端与 Tauri 应用
Write-Host "[STEP 3] Preparing and building Tauri application..." -ForegroundColor Blue
Push-Location Submarine-Client

Write-Host "Installing dependencies..."
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Error "npm install failed."
    Pop-Location
    exit 1
}

Write-Host "Running Tauri build..."
npm run tauri build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Tauri build failed."
    Pop-Location
    exit 1
}

Pop-Location

# 5. 重命名输出文件（添加版本和平台信息）
Write-Host "[STEP 4] Renaming output files with version and platform info..." -ForegroundColor Blue

# 获取版本号
if ($VersionArg) {
    $Version = $VersionArg
}
else {
    # 从 tauri.conf.json 读取版本
    $TauriConfig = Get-Content "Submarine-Client\src-tauri\tauri.conf.json" -Raw | ConvertFrom-Json
    $Version = "v" + $TauriConfig.version
}

$Platform = "x86_64"
$BundleDir = "target\release\bundle"

# 重命名 NSIS 安装程序
$NsisDir = "$BundleDir\nsis"
if (Test-Path $NsisDir) {
    $NsisFiles = Get-ChildItem -Path $NsisDir -Filter "*.exe"
    foreach ($file in $NsisFiles) {
        $NewName = "COSMOS-Submarine_${Version}_${Platform}.exe"
        if ($file.Name -eq $NewName) {
            Write-Host "  ✓ Already named correctly: $NewName" -ForegroundColor Gray
            continue
        }
        $NewPath = Join-Path $NsisDir $NewName
        if (Test-Path $NewPath) {
            Remove-Item $NewPath -Force
        }
        Move-Item $file.FullName $NewPath -Force
        Write-Host "  ✓ Renamed: $($file.Name) -> $NewName" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output locations:" -ForegroundColor White
Write-Host "  - Go sidecar binary: Core\bin\cosmos-submarine-core-x86_64-pc-windows-msvc.exe" -ForegroundColor Gray
Write-Host "  - Tauri bundles: target\release\bundle\" -ForegroundColor Gray
if (Test-Path "$BundleDir\nsis") {
    $NsisOutput = Get-ChildItem -Path "$BundleDir\nsis" -Filter "*.exe" | Select-Object -First 1
    if ($NsisOutput) {
        Write-Host "  - NSIS Installer: target\release\bundle\nsis\$($NsisOutput.Name)" -ForegroundColor Gray
    }
}
Write-Host ""
Read-Host "Press Enter to exit"
