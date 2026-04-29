# Implementation Guide

## Recommended Stack

This language works best with:

- Tauri.
- React or another component framework.
- Tailwind CSS.
- A small shared CSS utility layer.
- i18n for visible strings in production apps.

The style can be adapted to other stacks, but keep the same tokens and interaction rules.

## Setup Order

1. Add color, radius, shadow, blur, and animation tokens.
2. Add base font smoothing and platform font stack.
3. Add reusable utilities such as `glass-panel`, `btn-primary`, `btn-secondary`, `input-field`, and `mesh-gradient`.
4. Build shell surfaces first: app root, tray root, modal overlay.
5. Build components from the outside in: container, status, icon, copy, actions.

## Base CSS

Set body styling once:

```css
body {
  color: #1D1D1F;
  min-height: 100vh;
  background: transparent;
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  letter-spacing: -0.011em;
}
```

For tray windows, force transparent page backgrounds:

```css
html.tray-html,
body.tray-body {
  background: transparent !important;
  background-color: transparent !important;
  min-height: 100vh !important;
  height: 100vh !important;
  margin: 0 !important;
  padding: 0 !important;
  overflow: hidden !important;
}
```

## Reusable Utilities

Add utilities only when they encode a repeated visual primitive. Keep one-off layout decisions in component classes.

Good utilities:

- `glass-panel`
- `btn-primary`
- `btn-secondary`
- `input-field`
- `mesh-gradient`
- stateful mesh variants

Avoid utilities for every component. If a style is used once, keep it local.

## Tauri Constraints

Respect desktop-window behavior:

- Use transparent backgrounds for tray/menu windows.
- Use `data-tauri-drag-region` for custom title bars.
- Avoid browser-default context menus in polished production windows.
- Keep small windows from scrolling accidentally.
- Make clickable targets large enough for desktop pointer use.
- Hide tray windows after actions that open main windows or external URLs.

## i18n

For apps with localization:

- New visible text belongs in locale files.
- Keep status labels short.
- Avoid hardcoded uppercase strings if the language may not use uppercase naturally.
- Do not concatenate translated fragments when a full sentence is clearer.

## Component Construction

Build components in layers:

1. Outer positioning and size.
2. Glass surface.
3. Status affordance.
4. Icon or identity mark.
5. Title and concise description.
6. Actions.
7. Hover and active states.

This keeps visual depth independent from content logic.

## Verification

After edits:

- Check the focused file's TypeScript and lint diagnostics.
- Run the app if the change affects Tauri window sizing, transparency, or tray behavior.
- Run a frontend build when shared tokens or core components changed.
- Manually inspect hover, active, modal entry, and tray popup behavior.

## Portability

When applying this language to a new project:

- Keep the `apple-*` token names if Tailwind is available.
- If the product has a brand color, map that brand color to primary only if it has similar contrast and restraint.
- Preserve the state color semantics.
- Keep the system font stack unless the brand has a strong typography system.
- Start with fewer utilities, then add more only as repetition appears.
