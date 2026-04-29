#!/bin/bash

# COMAC VPN Build Script
# This script builds both the Go sidecar and Tauri application

set -e  # Exit on error

echo "======================================"
echo "COSMOS Submarine Build Script"
echo "======================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${RED}Error: Go is not installed${NC}"
    echo "Please install Go from https://golang.org/dl/"
    exit 1
fi

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}Error: Rust is not installed${NC}"
    echo "Please install Rust from https://rustup.rs/"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed${NC}"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

TARGETS=()

print_usage() {
    echo ""
    echo "Usage:"
    echo "  ./build.sh                          # build for native target"
    echo "  ./build.sh --version v2.1.0         # set version and build"
    echo "  ./build.sh --clean                  # force clean build artifacts"
    echo "  ./build.sh --targets <list>         # build for specific targets"
    echo "  ./build.sh --no-bundle              # build only, skip DMG bundling"
    echo "  ./build.sh --codesign <identity>    # code sign .app and DMG with certificate"
    echo ""
    echo "Targets (comma-separated):"
    echo "  universal-apple-darwin      (macOS Universal: x64 + arm64)"
    echo "  x86_64-apple-darwin"
    echo "  aarch64-apple-darwin"
    echo "  x86_64-unknown-linux-gnu"
    echo "  aarch64-unknown-linux-gnu"
    echo "  x86_64-pc-windows-msvc"
    echo ""
}

VERSION=""
NO_BUNDLE=false
CODESIGN_IDENTITY=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --targets)
            IFS=',' read -r -a TARGETS <<< "$2"
            shift 2
            ;;
        --version|-v)
            VERSION="$2"
            shift 2
            ;;
        --no-bundle)
            NO_BUNDLE=true
            shift
            ;;
        --codesign)
            CODESIGN_IDENTITY="$2"
            shift 2
            ;;
        --clean|-c|-f)
            CLEAN_MODE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown argument: $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

# Pre-build check for Rust targets
for target in "${TARGETS[@]}"; do
    case "$target" in
        universal-apple-darwin)
            echo -e "${BLUE}Ensuring Rust targets for universal build...${NC}"
            rustup target add x86_64-apple-darwin aarch64-apple-darwin
            ;;
        x86_64-apple-darwin)
            echo -e "${BLUE}Ensuring Rust target for x64 build...${NC}"
            rustup target add x86_64-apple-darwin
            ;;
        aarch64-apple-darwin)
            echo -e "${BLUE}Ensuring Rust target for ARM64 build...${NC}"
            rustup target add aarch64-apple-darwin
            ;;
    esac
done

resolve_sidecar_targets() {
    local t="$1"
    case "$t" in
        x86_64-apple-darwin)
            echo "sidecar-darwin-amd64"
            ;;
        aarch64-apple-darwin)
            echo "sidecar-darwin-arm64"
            ;;
        x86_64-unknown-linux-gnu)
            echo "sidecar-linux-amd64"
            ;;
        aarch64-unknown-linux-gnu)
            echo "sidecar-linux-arm64"
            ;;
        x86_64-pc-windows-msvc)
            echo "sidecar-windows-amd64"
            ;;
        universal-apple-darwin)
            echo "sidecar-darwin-amd64 sidecar-darwin-arm64"
            ;;
        *)
            echo ""
            ;;
    esac
}

# --- PRE-STEP: Cleaning old build artifacts ---
if [ "$CLEAN_MODE" = true ]; then
    echo -e "${BLUE}PRE-STEP: Cleaning old build artifacts...${NC}"
    rm -rf target/
    rm -rf Submarine-Client/src-tauri/target/
    rm -rf Submarine-Client/dist/
    rm -rf Submarine-Client/out/
    rm -rf Core/bin/*.exe Core/bin/cosmos-submarine-core-*
else
    echo -e "${BLUE}PRE-STEP: Skipping clean (use --clean or -c to force full rebuild)${NC}"
fi
echo -e "${BLUE}Step 1: Building Go sidecar binaries...${NC}"
cd Core
mkdir -p bin
if [ ${#TARGETS[@]} -eq 0 ]; then
    # Auto-detect host platform for default build
    OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m)"

    echo "Detected host: ${OS}-${ARCH}"

    if [ "$OS" == "darwin" ]; then
        if [ "$ARCH" == "arm64" ]; then
            make sidecar-darwin-arm64 TAGS=release
        else
            make sidecar-darwin-amd64 TAGS=release
        fi
    elif [ "$OS" == "linux" ]; then
        if [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
            make sidecar-linux-arm64 TAGS=release
        else
            make sidecar-linux-amd64 TAGS=release
        fi
    elif [[ "$OS" == "mingw"* ]] || [[ "$OS" == "msys"* ]]; then
        make sidecar-windows-amd64 TAGS=release
    else
        # Fallback to all if detection fails or unknown
        make sidecar-all TAGS=release
    fi
else
    for target in "${TARGETS[@]}"; do
        sidecar_targets=$(resolve_sidecar_targets "$target")
        if [ -z "$sidecar_targets" ]; then
            echo -e "${RED}Unsupported target for sidecar: ${target}${NC}"
            exit 1
        fi
        make ${sidecar_targets} TAGS=release

        # If target is universal-apple-darwin, create a universal binary for the sidecar
        if [ "$target" == "universal-apple-darwin" ]; then
            echo -e "${BLUE}Creating universal sidecar binary...${NC}"
            lipo -create bin/cosmos-submarine-core-x86_64-apple-darwin bin/cosmos-submarine-core-aarch64-apple-darwin -output bin/cosmos-submarine-core-universal-apple-darwin
        fi
    done
fi
echo -e "${GREEN}✓ Go sidecar binaries built successfully${NC}"
cd ..

echo -e "${BLUE}Step 2: Preparing and installing frontend dependencies...${NC}"
cd Submarine-Client
if [ ! -z "$VERSION" ]; then
    echo -e "${BLUE}Setting version to $VERSION...${NC}"
    node update-version.js "$VERSION"
fi
npm install
echo -e "${GREEN}✓ Frontend dependencies installed${NC}"

echo -e "${BLUE}Step 2.5: Regenerating app icons...${NC}"
npm run tauri icon src-tauri/icons/icon_source.png

echo -e "${BLUE}Step 3: Building Tauri application...${NC}"

# Check for code signing identity on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -z "$CODESIGN_IDENTITY" ]; then
        # Try to get from environment variable
        CODESIGN_IDENTITY="${APPLE_SIGNING_IDENTITY:-}"
    fi

    if [ -z "$CODESIGN_IDENTITY" ]; then
        echo -e "${YELLOW}⚠️  WARNING: No code signing identity provided!${NC}"
        echo -e "${YELLOW}   The app will be signed with ad-hoc signature (temporary).${NC}"
        echo -e "${YELLOW}   Users will need to manually allow it in System Preferences > Security & Privacy.${NC}"
        echo -e "${YELLOW}   To use proper signing, provide --codesign parameter or set APPLE_SIGNING_IDENTITY env var.${NC}"
        echo ""
        if [ -t 0 ]; then
            # Interactive terminal
            read -p "Continue with ad-hoc signing? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Build cancelled."
                exit 1
            fi
        else
            # Non-interactive (CI/CD), just warn and continue
            echo -e "${YELLOW}   Continuing with ad-hoc signing (non-interactive mode)...${NC}"
        fi
    else
        # Verify the certificate exists
        if ! security find-identity -v -p codesigning | grep -q "$CODESIGN_IDENTITY"; then
            echo -e "${RED}❌ Error: Code signing identity not found: ${CODESIGN_IDENTITY}${NC}"
            echo "Available identities:"
            security find-identity -v -p codesigning | grep "Developer ID"
            exit 1
        fi
        echo -e "${GREEN}✓ Code signing identity verified: ${CODESIGN_IDENTITY}${NC}"
        export APPLE_SIGNING_IDENTITY="$CODESIGN_IDENTITY"
    fi
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
    # Auto-detect platform and add appropriate bundle targets
    OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    if [ "$OS" == "darwin" ]; then
        npm run tauri build -- --bundles app
    else
        npm run tauri build
    fi
else
    for target in "${TARGETS[@]}"; do
        # Add --bundles app for macOS targets
        case "$target" in
            x86_64-apple-darwin|aarch64-apple-darwin|universal-apple-darwin)
                npm run tauri build -- --target "$target" --bundles app
                ;;
            *)
                npm run tauri build -- --target "$target"
                ;;
        esac
    done
fi
echo -e "${GREEN}✓ Tauri application built successfully${NC}"

# Manual DMG bundling for macOS
if [[ "$OSTYPE" == "darwin"* ]] && [ "$NO_BUNDLE" = false ]; then
    echo -e "${BLUE}Step 4: Bundling DMG manually (skipping AppleScript)...${NC}"

    if [ -z "$VERSION" ]; then
        VERSION=$(grep '"version":' src-tauri/tauri.conf.json | head -n 1 | cut -d'"' -f4)
    fi

    mkdir -p ../target/release/bundle/dmg

    BUNDLE_DMG() {
        local arch=$1
        local target_name="COSMOS-Submarine_${VERSION}_${arch}.dmg"
        echo -e "${BLUE}Bundling $target_name...${NC}"

        # Determine target triple for path resolution
        local TARGET_TRIPLE=""
        if [ "$arch" == "aarch64" ]; then
            TARGET_TRIPLE="aarch64-apple-darwin"
        elif [ "$arch" == "x86_64" ]; then
            TARGET_TRIPLE="x86_64-apple-darwin"
        elif [ "$arch" == "universal" ]; then
            TARGET_TRIPLE="universal-apple-darwin"
        fi

        # Try multiple possible locations for the .app bundle
        local APP_PATH=""

        # First, try src-tauri/target (Tauri's default output location)
        if [ -n "$TARGET_TRIPLE" ]; then
            APP_PATH="src-tauri/target/${TARGET_TRIPLE}/release/bundle/macos/COSMOS-Submarine.app"
        fi

        # If not found, try project root target directory
        if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
            if [ -n "$TARGET_TRIPLE" ]; then
                APP_PATH="../target/${TARGET_TRIPLE}/release/bundle/macos/COSMOS-Submarine.app"
            fi
        fi

        # Fallback to default release directory
        if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
            local FALLBACK_PATH="src-tauri/target/release/bundle/macos/COSMOS-Submarine.app"
            if [ -d "$FALLBACK_PATH" ]; then
                echo "⚠️ Target specific app not found, using fallback: $FALLBACK_PATH"
                APP_PATH="$FALLBACK_PATH"
            fi
        fi

        # Last fallback to project root
        if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
            local FALLBACK_PATH="../target/release/bundle/macos/COSMOS-Submarine.app"
            if [ -d "$FALLBACK_PATH" ]; then
                echo "⚠️ Using project root fallback: $FALLBACK_PATH"
                APP_PATH="$FALLBACK_PATH"
            fi
        fi

        if [ ! -d "$APP_PATH" ]; then
            echo -e "${RED}❌ Error: .app bundle not found for $arch${NC}"
            echo "Searched locations:"
            [ -n "$TARGET_TRIPLE" ] && echo "  - src-tauri/target/${TARGET_TRIPLE}/release/bundle/macos/COSMOS-Submarine.app"
            [ -n "$TARGET_TRIPLE" ] && echo "  - ../target/${TARGET_TRIPLE}/release/bundle/macos/COSMOS-Submarine.app"
            echo "  - src-tauri/target/release/bundle/macos/COSMOS-Submarine.app"
            echo "  - ../target/release/bundle/macos/COSMOS-Submarine.app"
            return 1
        fi

        echo "✓ Found .app bundle at: $APP_PATH"

        # Sign the .app bundle
        if [ -n "$CODESIGN_IDENTITY" ]; then
            echo -e "${BLUE}Code signing .app bundle with identity: ${CODESIGN_IDENTITY}...${NC}"
            codesign --force --deep --sign "${CODESIGN_IDENTITY}" "${APP_PATH}" || {
                echo -e "${RED}❌ Code signing failed for .app bundle${NC}"
                exit 1
            }
            echo -e "${GREEN}✓ .app bundle signed successfully${NC}"
        else
            # Ad-hoc sign the .app (temporary signature for local testing)
            echo -e "${BLUE}Performing Ad-hoc signing for ${APP_PATH} (no certificate provided)...${NC}"
            codesign --force --deep --sign - "${APP_PATH}" || echo "⚠️ Ad-hoc signing failed, continuing..."
        fi

        if [ -f "../target/release/bundle/dmg/$target_name" ]; then
            echo "Removing existing DMG: ../target/release/bundle/dmg/$target_name"
            rm "../target/release/bundle/dmg/$target_name"
        fi

        # Build bundle_dmg.sh command with optional codesign
        BUNDLE_DMG_CMD="bash ../scripts/bundle_dmg.sh \
            --skip-jenkins \
            --volname \"COSMOS-Submarine\" \
            --volicon src-tauri/icons/icon.icns \
            --window-pos 200 120 \
            --window-size 600 400 \
            --icon-size 100 \
            --icon \"COSMOS-Submarine\" 180 170 \
            --app-drop-link 420 170"

        # Add codesign parameter if identity is provided
        if [ -n "$CODESIGN_IDENTITY" ]; then
            BUNDLE_DMG_CMD="${BUNDLE_DMG_CMD} --codesign \"${CODESIGN_IDENTITY}\""
        fi

        BUNDLE_DMG_CMD="${BUNDLE_DMG_CMD} \
            \"../target/release/bundle/dmg/$target_name\" \
            \"${APP_PATH}\""

        eval $BUNDLE_DMG_CMD
    }

    if [ ${#TARGETS[@]} -eq 0 ]; then
        ARCH=$(uname -m)
        BUNDLE_DMG "$ARCH"
    else
        for target in "${TARGETS[@]}"; do
            case "$target" in
                aarch64-apple-darwin) BUNDLE_DMG "aarch64" ;;
                x86_64-apple-darwin) BUNDLE_DMG "x86_64" ;;
                universal-apple-darwin) BUNDLE_DMG "universal" ;;
            esac
        done
    fi
    echo -e "${GREEN}✓ DMG bundled successfully${NC}"
fi

echo ""
echo -e "${GREEN}======================================"
echo "Build completed successfully!"
echo "======================================"
echo -e "${NC}"
echo "Output locations:"
echo "  - Go sidecar binaries: Core/bin/"
echo "  - Tauri bundles: target/release/bundle/"
echo ""
