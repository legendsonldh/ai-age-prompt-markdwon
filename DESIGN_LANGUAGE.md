# Design Language

## Personality

This UI language is for professional desktop utilities that should feel native, calm, and carefully made. It borrows from macOS and iOS visual conventions without copying system apps outright.

The product should feel:

- Calm rather than loud.
- Precise rather than decorative.
- Trustworthy rather than playful.
- Premium through restraint rather than luxury ornament.
- Operational and useful rather than marketing-heavy.

## Visual Thesis

Use glass as an interface material, not as an effect pasted on top.

The app shell should feel like a soft, luminous environment. Panels float over a pale mesh background. Important controls use Apple Blue. Health and status are conveyed with small chips, dots, and concise labels. Typography is compact and confident.

## Composition

- Prefer centered desktop layouts with a clear maximum width.
- Use a fixed-feeling top identity/status zone for main windows.
- Put operational details into compact groups instead of wide tables.
- Use cards for destinations, features, modules, services, or tasks.
- Keep the interface readable at small desktop-window sizes.
- Use generous radii to make surfaces feel native and touchable.

## Information Hierarchy

Use four text levels:

- Product or page title: bold, tight tracking, dark Apple gray.
- Section or card title: bold, compact, visually stable.
- Description: short, muted, medium weight.
- Metadata label: tiny, uppercase, bold, widely tracked.

Do not let explanatory copy dominate the screen. Utility apps earn trust by showing the right state at the right time.

## State Language

State should be visible but not theatrical.

- Active or primary: Apple Blue.
- Healthy or complete: green.
- Failed or offline: red.
- Degraded or caution: orange.
- Inactive or waiting: muted gray, sometimes with a subtle pulse.

Always pair color with text or iconography. A dot alone is not enough.

## Platform Feel

Tauri apps often bridge web UI and desktop behavior. This language should hide that seam:

- Use custom title bars when the window frame needs to feel integrated.
- Keep tray popups compact and window-like, not web-page-like.
- Avoid browser affordances such as large nav bars, link-heavy layouts, and page-like modals.
- Preserve draggable regions and transparent backgrounds where the shell requires them.

## Anti-Patterns

Avoid:

- Cyberpunk, neon, or black glass surfaces.
- Flat white enterprise dashboards.
- Generic SaaS card grids with default blue buttons.
- Excessive gradients that make state hard to read.
- Huge marketing headlines in utility surfaces.
- Overly playful microcopy.
- Tables used where compact cards or stat groups would communicate faster.
