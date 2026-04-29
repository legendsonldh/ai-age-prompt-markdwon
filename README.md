# Tauri Client Skills

This repository contains reusable Skill documents for Tauri desktop client work.

## Skill Entries

- [TAURI_APPLE_GLASS_UI_SKILL.md](TAURI_APPLE_GLASS_UI_SKILL.md): Direct Skill entry for Apple-inspired Tauri UI development.
- [SKILL.md](SKILL.md): Detailed Apple Glass UI Skill.
- [tauri-client-build-packaging/SKILL.md](tauri-client-build-packaging/SKILL.md): Build and packaging Skill for macOS/Windows Tauri clients.
- [go-react-admin-platform/SKILL.md](go-react-admin-platform/SKILL.md): Full-stack Skill for Go/Gin/GORM backends with React/Vite admin frontends.

## Apple Glass UI Documents

- [DESIGN_LANGUAGE.md](DESIGN_LANGUAGE.md): Product feel, visual thesis, hierarchy, and anti-patterns.
- [TOKENS.md](TOKENS.md): Color, typography, radius, shadow, blur, and reusable CSS utilities.
- [COMPONENT_PATTERNS.md](COMPONENT_PATTERNS.md): App shell, main window, tray popup, cards, chips, modals, inputs, buttons, floating controls, and title bars.
- [MOTION_AND_INTERACTION.md](MOTION_AND_INTERACTION.md): Motion personality, timing, hover, active, loading, tray behavior, and accessibility.
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md): Tailwind/React/Tauri setup, CSS strategy, i18n, verification, and portability.
- [EXAMPLES.md](EXAMPLES.md): Copyable component recipes.
- [REFERENCE_IMPLEMENTATION.md](REFERENCE_IMPLEMENTATION.md): Concrete style tokens, CSS utilities, and component class recipes from the original implementation.

## Build Packaging Documents

- [tauri-client-build-packaging/README.md](tauri-client-build-packaging/README.md): Build Skill index.
- [tauri-client-build-packaging/PIPELINE.md](tauri-client-build-packaging/PIPELINE.md): Build pipeline and target mapping.
- [tauri-client-build-packaging/MACOS_DMG.md](tauri-client-build-packaging/MACOS_DMG.md): macOS app and DMG packaging.
- [tauri-client-build-packaging/WINDOWS_NSIS.md](tauri-client-build-packaging/WINDOWS_NSIS.md): Windows sidecar and NSIS packaging.
- [tauri-client-build-packaging/SIDECAR_AND_VERSIONING.md](tauri-client-build-packaging/SIDECAR_AND_VERSIONING.md): Sidecar and version contracts.
- [tauri-client-build-packaging/TROUBLESHOOTING.md](tauri-client-build-packaging/TROUBLESHOOTING.md): Build failure diagnosis.

## Go React Admin Platform Documents

- [go-react-admin-platform/README.md](go-react-admin-platform/README.md): Full-stack Skill index.
- [go-react-admin-platform/BACKEND_GIN.md](go-react-admin-platform/BACKEND_GIN.md): Go/Gin backend patterns.
- [go-react-admin-platform/DATABASE_GORM_SQLITE.md](go-react-admin-platform/DATABASE_GORM_SQLITE.md): Database and retention patterns.
- [go-react-admin-platform/FRONTEND_REACT_VITE.md](go-react-admin-platform/FRONTEND_REACT_VITE.md): React/Vite frontend patterns.
- [go-react-admin-platform/REALTIME_SSE.md](go-react-admin-platform/REALTIME_SSE.md): Realtime SSE patterns.
- [go-react-admin-platform/FILES_RELEASES_AUDIT.md](go-react-admin-platform/FILES_RELEASES_AUDIT.md): File, release, and audit patterns.
- [go-react-admin-platform/DEPLOYMENT_DOCKER.md](go-react-admin-platform/DEPLOYMENT_DOCKER.md): Docker deployment patterns.
- [go-react-admin-platform/TROUBLESHOOTING.md](go-react-admin-platform/TROUBLESHOOTING.md): Full-stack troubleshooting.

## Intended UI Use

Use this series when a desktop utility should feel:

- macOS-native.
- light and translucent.
- operationally clear.
- compact but premium.
- calm under repeated daily use.

It is intentionally not tied to any single repository or product domain.
