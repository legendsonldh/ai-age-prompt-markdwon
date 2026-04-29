# Motion And Interaction

## Motion Personality

Motion should feel tactile and native. The goal is confidence, not spectacle.

Use animation to communicate:

- A surface entering the desktop space.
- A control responding to touch or pointer input.
- A state changing from inactive to active.
- A background gently reflecting app state.

Do not animate everything. A utility app should stay calm under repeated use.

## Timing

Recommended defaults:

```js
animation: {
  'fade-in': 'fadeIn 0.6s ease-out forwards',
  'slide-up': 'slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards',
  'scale-in': 'scaleIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards',
  'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
}
```

```js
keyframes: {
  fadeIn: {
    '0%': { opacity: '0' },
    '100%': { opacity: '1' },
  },
  slideUp: {
    '0%': { opacity: '0', transform: 'translateY(20px)' },
    '100%': { opacity: '1', transform: 'translateY(0)' },
  },
  scaleIn: {
    '0%': { opacity: '0', transform: 'scale(0.95)' },
    '100%': { opacity: '1', transform: 'scale(1)' },
  },
}
```

## Entry Motion

Use:

- `animate-fade-in` for screens and overlays.
- `animate-slide-up` for dialogs and modal panels.
- `animate-scale-in` for loading cards and compact centered panels.

Avoid chaining many entry animations. One orchestrated entrance is enough.

## Hover

Hover should slightly reveal depth:

- Cards: scale to `1.01` or `1.02`, lift by `2px` to `4px`.
- Buttons: translate up by `1px` to `2px`.
- Icon tiles: scale to `1.05`.
- Text: shift from muted gray to Apple Blue only when the element is interactive.

Avoid dramatic translation, rotation, or bouncy effects.

## Active Press

Pressed states should compress:

- `active:scale-95` for circular/floating controls.
- `active:scale-[0.98]` for primary buttons.
- Use inner shadow sparingly for primary button press.

## State Transitions

Background state transitions can be slower:

- Neutral to active: `duration-1000`.
- Active to error: `duration-700` to `duration-1000`.
- Chip/dot color changes: `duration-300` to `duration-500`.

Use glow only for tiny status dots, not entire cards.

## Waiting And Loading

Use calm waiting indicators:

- Spinner inside a glass panel for initialization.
- Slow pulse for monitoring or pending states.
- Tiny animated dot for checking state.

Avoid large skeleton screens for compact desktop utilities unless loading a complex data view.

## Tray Interaction

Tray windows should feel immediate:

- Enter with quick fade/zoom.
- Buttons respond with fast hover and press states.
- After launching a main window or external URL, hide the tray.
- Avoid long transitions that make the menu feel sticky.

## Accessibility

- Never rely on motion alone to convey state.
- Keep focus states visible.
- Respect reduced-motion settings if the app already has accessibility infrastructure.
- Avoid infinite animation except for small waiting indicators.
