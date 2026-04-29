# Component Patterns

## App Shell

Use a full-height shell with a soft stateful background:

- `h-screen`
- `mesh-gradient`
- `overflow-hidden`
- `font-sans`
- `text-apple-gray-500`
- `selection:bg-apple-blue/20 selection:text-apple-blue`
- `transition-all duration-1000` for background state changes

The app shell should hold global floating controls, view/state switching, and modal overlays.

## Main Window

Main windows should feel like desktop control surfaces, not web pages.

Recommended structure:

1. Fixed-feeling identity/status header.
2. Primary operational controls.
3. Compact stats and service cards.
4. Secondary diagnostics or shortcuts.

Guidelines:

- Keep content within `max-w-[1000px]` unless the app is truly data-heavy.
- Use `p-4 lg:p-6` for outer breathing room.
- Prefer flex or small grids over large tables.
- Use `glass-panel rounded-[2rem]` for top status bands.
- Place high-frequency state near the top.

## Tray Or Menu-Bar Popup

Tray popups should be compact, rounded, and self-contained.

Recommended dimensions:

- Width around `292px` to `320px`.
- Container: `bg-white/95 backdrop-blur-2xl rounded-[2.5rem] border border-white/40 ring-1 ring-black/5`.
- Use `overflow-hidden` so the glass object feels physical.

Recommended sections:

- Profile or app identity.
- Compact status/metric block.
- Shortcut buttons.
- Optional selector or segmented control.
- One primary action and one quiet destructive/quit action if needed.

Behavior:

- Hide the popup after opening a main window or external URL.
- Do not build complex workflows inside the tray. Hand off to the main window.

## Cards

Cards represent modules, destinations, services, checks, or tasks.

Structure:

- Full-card clickable group when the action is obvious.
- Absolute glass background layer.
- Top-right status chip for availability or state.
- Center icon tile.
- Title and one short description.

Visual behavior:

- `group-hover:scale-[1.02]`
- `group-hover:shadow-apple-hover`
- `group-hover:bg-white/80`
- Content can move by `group-hover:-translate-y-0.5`.

Avoid mixing too many controls into one card. If a card has more than one primary action, split it.

## Status Chips

Use chips for state rather than large banners.

Recommended anatomy:

- Tiny dot.
- Uppercase label.
- Translucent white capsule.
- Soft border and subtle shadow.

Examples:

- Online: green dot, green label.
- Offline: red dot, red label.
- Waiting: gray or blue pulsing dot.
- Active: blue accent plus health color if needed.

## Modals

Modals should feel like native dialogs.

Overlay:

- `fixed inset-0 z-50`
- `bg-black/60`
- `backdrop-blur-md`
- `animate-fade-in`

Body:

- `glass-panel`
- `rounded-[2rem]`
- `p-8`
- `animate-slide-up`
- `relative overflow-hidden`

Use one decorative low-opacity blue blur orb at most. The dialog should remain functional and readable.

Footer:

- Separate with `border-t border-black/5`.
- Align primary action to the right unless the modal is wizard-like.
- Use secondary buttons for cancellation or retries.

## Inputs

Inputs should be quiet, glassy, and comfortable:

- `bg-white/50`
- `backdrop-blur-md`
- `rounded-xl`
- `px-5 py-4`
- `text-apple-gray-500`
- subtle ring or border
- blue focus ring

Avoid harsh outlines. Focus should feel luminous, not browser-default.

## Buttons

Primary:

- Apple Blue background.
- White text.
- Rounded square shape.
- Slight upward hover.
- Press compression on active.

Secondary:

- White translucent background.
- Muted gray text.
- Hover to white and darker text.

Danger:

- Prefer quiet red text or red-tinted hover unless the action is immediately destructive.

## Floating Controls

Floating buttons are appropriate for help, language, compact settings, or assistant affordances.

Use:

- `fixed bottom-8 left-8`
- `w-12 h-12`
- `rounded-full`
- `glass-panel bg-white/70 backdrop-blur-md`
- `hover:scale-110 active:scale-95`

Keep count low. Two floating controls is usually the maximum.

## Custom Title Bar

When using a custom title bar:

- Mark drag regions correctly with `data-tauri-drag-region`.
- Use translucent white with blur.
- Use macOS traffic-light dots as subtle affordances only when appropriate.
- Keep title text tiny, uppercase, and low-contrast.
- Provide minimize and close buttons with clear hover states.
