---
name: tauri-apple-glass-ui
description: Design and implement Tauri desktop app UIs using an Apple-inspired light glassmorphism language. Use when building or refining React/Tauri windows, tray panels, modals, status cards, onboarding, settings, dashboards, and shared styling.
---

# Tauri Apple Glass UI

## When To Use

Use this skill for Tauri desktop UI work that should feel macOS-native, light, translucent, precise, and quietly premium.

Best fit:

- Main desktop windows.
- Tray or menu-bar popups.
- Onboarding, registration, account, settings, and update modals.
- Dashboards, status cards, compact monitoring panels, and utility controls.
- Shared Tailwind/CSS design tokens for desktop apps.

Avoid this skill for marketing landing pages, game UI, mobile-first apps, heavy enterprise tables, or dark/cyberpunk interfaces.

## Core Direction

Create a light-mode-first Apple glass interface:

- Translucent white surfaces over soft mesh gradients.
- Apple Blue as the primary action and active-state accent.
- Tiny uppercase technical labels for metadata.
- Rounded squircles, soft shadows, quiet borders, and subtle depth.
- Tactile motion: hover lifts, active states compress, entry transitions fade/slide/scale.
- Operational clarity over decoration.

## Workflow

1. Identify the surface type: main window, tray popup, modal, card, floating control, or shared token layer.
2. Read the relevant reference file before editing:
   - [DESIGN_LANGUAGE.md](DESIGN_LANGUAGE.md)
   - [TOKENS.md](TOKENS.md)
   - [COMPONENT_PATTERNS.md](COMPONENT_PATTERNS.md)
   - [MOTION_AND_INTERACTION.md](MOTION_AND_INTERACTION.md)
   - [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
   - [EXAMPLES.md](EXAMPLES.md)
   - [REFERENCE_IMPLEMENTATION.md](REFERENCE_IMPLEMENTATION.md)
3. Reuse existing project tokens first. If none exist, introduce the minimal token set from `TOKENS.md`.
4. Preserve Tauri constraints: transparent tray windows, draggable regions, compact dimensions, and no browser-like chrome.
5. Keep visible strings localizable when the app already uses i18n.
6. Verify TypeScript/lint/build checks when practical.

## Non-Negotiables

- Do not introduce dark mode unless explicitly requested.
- Do not replace the glass language with generic SaaS cards.
- Do not add random accent colors that compete with Apple Blue.
- Do not use color alone for state; pair dots or chips with labels.
- Do not over-animate utility interfaces.
