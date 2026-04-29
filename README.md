# AI Age Prompt Markdown Skills

This repository contains reusable Skill documents and reference patterns extracted from production engineering work.

## Skill Entries

- [skills/tauri-apple-glass-ui/TAURI_APPLE_GLASS_UI_SKILL.md](skills/tauri-apple-glass-ui/TAURI_APPLE_GLASS_UI_SKILL.md): Direct Skill entry for Apple-inspired Tauri UI development.
- [skills/tauri-apple-glass-ui/SKILL.md](skills/tauri-apple-glass-ui/SKILL.md): Detailed Apple Glass UI Skill.
- [skills/tauri-client-build-packaging/SKILL.md](skills/tauri-client-build-packaging/SKILL.md): Build and packaging Skill for macOS/Windows Tauri clients.
- [skills/go-react-admin-platform/SKILL.md](skills/go-react-admin-platform/SKILL.md): Full-stack Skill for Go/Gin/GORM backends with React/Vite admin frontends.

## Directory Layout

```text
skills/
  tauri-apple-glass-ui/
  tauri-client-build-packaging/
  go-react-admin-platform/
```

## Apple Glass UI Documents

- [skills/tauri-apple-glass-ui/DESIGN_LANGUAGE.md](skills/tauri-apple-glass-ui/DESIGN_LANGUAGE.md): Product feel, visual thesis, hierarchy, and anti-patterns.
- [skills/tauri-apple-glass-ui/TOKENS.md](skills/tauri-apple-glass-ui/TOKENS.md): Color, typography, radius, shadow, blur, and reusable CSS utilities.
- [skills/tauri-apple-glass-ui/COMPONENT_PATTERNS.md](skills/tauri-apple-glass-ui/COMPONENT_PATTERNS.md): App shell, main window, tray popup, cards, chips, modals, inputs, buttons, floating controls, and title bars.
- [skills/tauri-apple-glass-ui/MOTION_AND_INTERACTION.md](skills/tauri-apple-glass-ui/MOTION_AND_INTERACTION.md): Motion personality, timing, hover, active, loading, tray behavior, and accessibility.
- [skills/tauri-apple-glass-ui/IMPLEMENTATION_GUIDE.md](skills/tauri-apple-glass-ui/IMPLEMENTATION_GUIDE.md): Tailwind/React/Tauri setup, CSS strategy, i18n, verification, and portability.
- [skills/tauri-apple-glass-ui/EXAMPLES.md](skills/tauri-apple-glass-ui/EXAMPLES.md): Copyable component recipes.
- [skills/tauri-apple-glass-ui/REFERENCE_IMPLEMENTATION.md](skills/tauri-apple-glass-ui/REFERENCE_IMPLEMENTATION.md): Concrete style tokens, CSS utilities, and component class recipes from the original implementation.

## Build Packaging Documents

- [skills/tauri-client-build-packaging/README.md](skills/tauri-client-build-packaging/README.md): Build Skill index.
- [skills/tauri-client-build-packaging/PIPELINE.md](skills/tauri-client-build-packaging/PIPELINE.md): Build pipeline and target mapping.
- [skills/tauri-client-build-packaging/MACOS_DMG.md](skills/tauri-client-build-packaging/MACOS_DMG.md): macOS app and DMG packaging.
- [skills/tauri-client-build-packaging/WINDOWS_NSIS.md](skills/tauri-client-build-packaging/WINDOWS_NSIS.md): Windows sidecar and NSIS packaging.
- [skills/tauri-client-build-packaging/SIDECAR_AND_VERSIONING.md](skills/tauri-client-build-packaging/SIDECAR_AND_VERSIONING.md): Sidecar and version contracts.
- [skills/tauri-client-build-packaging/TROUBLESHOOTING.md](skills/tauri-client-build-packaging/TROUBLESHOOTING.md): Build failure diagnosis.

## Go React Admin Platform Documents

- [skills/go-react-admin-platform/README.md](skills/go-react-admin-platform/README.md): Full-stack Skill index.
- [skills/go-react-admin-platform/BACKEND_GIN.md](skills/go-react-admin-platform/BACKEND_GIN.md): Go/Gin backend patterns.
- [skills/go-react-admin-platform/DATABASE_GORM_SQLITE.md](skills/go-react-admin-platform/DATABASE_GORM_SQLITE.md): Database and retention patterns.
- [skills/go-react-admin-platform/FRONTEND_REACT_VITE.md](skills/go-react-admin-platform/FRONTEND_REACT_VITE.md): React/Vite frontend patterns.
- [skills/go-react-admin-platform/REALTIME_SSE.md](skills/go-react-admin-platform/REALTIME_SSE.md): Realtime SSE patterns.
- [skills/go-react-admin-platform/FILES_RELEASES_AUDIT.md](skills/go-react-admin-platform/FILES_RELEASES_AUDIT.md): File, release, and audit patterns.
- [skills/go-react-admin-platform/DEPLOYMENT_DOCKER.md](skills/go-react-admin-platform/DEPLOYMENT_DOCKER.md): Docker deployment patterns.
- [skills/go-react-admin-platform/TROUBLESHOOTING.md](skills/go-react-admin-platform/TROUBLESHOOTING.md): Full-stack troubleshooting.

## Intended UI Use

Use this series when a desktop utility should feel:

- macOS-native.
- light and translucent.
- operationally clear.
- compact but premium.
- calm under repeated daily use.

It is intentionally not tied to any single repository or product domain.
