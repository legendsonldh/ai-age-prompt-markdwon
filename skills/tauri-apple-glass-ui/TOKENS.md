# Tokens

## Color

Use a small palette. The restraint is part of the identity.

```js
colors: {
  apple: {
    blue: '#007AFF',
    'blue-dark': '#0055b3',
    gray: {
      50: '#F5F5F7',
      100: '#E8E8ED',
      200: '#D2D2D7',
      300: '#86868B',
      400: '#424245',
      500: '#1D1D1F',
      600: '#000000',
    },
    glass: {
      light: 'rgba(255, 255, 255, 0.7)',
      dark: 'rgba(29, 29, 31, 0.7)',
      border: 'rgba(255, 255, 255, 0.5)',
    },
  },
}
```

Semantic usage:

- `#007AFF`: primary actions, selected state, active accent.
- Green: healthy, online, complete, successful.
- Red: offline, failed, destructive, blocked.
- Orange: degraded, warning, slow, caution.
- Apple gray: base text, secondary text, disabled state, dividers.

## Typography

Use the platform stack by default:

```css
font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
letter-spacing: -0.011em;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
```

Recommended text treatments:

- Titles: `font-bold tracking-tight text-apple-gray-500`.
- Body: `font-medium text-apple-gray-400`.
- Metadata: `text-[9px] font-bold uppercase tracking-widest text-apple-gray-300`.
- Metrics: `font-mono font-bold tracking-tight`.

## Radius

Use large radii consistently:

```js
borderRadius: {
  xl: '1rem',
  '2xl': '1.25rem',
  '3xl': '1.5rem',
  '4xl': '2rem',
  apple: '1.25rem',
}
```

Guidance:

- Small buttons and chips: `rounded-lg` to `rounded-xl`.
- Cards and nested panels: `rounded-2xl` to `rounded-[2rem]`.
- Tray/menu containers: `rounded-[2.5rem]`.
- Icon tiles: `rounded-xl` to `rounded-2xl`.

## Shadows

Keep shadows soft and spatial:

```js
boxShadow: {
  apple: '0 8px 30px rgba(0, 0, 0, 0.04)',
  'apple-hover': '0 14px 40px rgba(0, 0, 0, 0.08)',
  'apple-active': '0 4px 12px rgba(0, 0, 0, 0.06)',
  glass: '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
  'inner-light': 'inset 0 1px 1px rgba(255, 255, 255, 0.4)',
}
```

Avoid hard black shadows. If the app feels heavy, reduce opacity before reducing blur.

## Blur

```js
backdropBlur: {
  xs: '2px',
  md: '12px',
  lg: '20px',
  xl: '40px',
}
```

Use `backdrop-blur-md` for small floating controls, `backdrop-blur-xl` or `backdrop-blur-2xl` for major glass surfaces.

## Base Utilities

Recommended reusable utilities:

```css
.glass-panel {
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
}

.mesh-gradient {
  background-color: #f5f5f7;
  background-image:
    radial-gradient(at 0% 0%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(200, 220, 255, 0.4) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 0% 100%, rgba(230, 240, 255, 0.5) 0px, transparent 50%);
}
```

## State Backgrounds

Use state backgrounds at the app shell level, not inside every component:

- Neutral: pale gray mesh.
- Active: pale blue mesh with low-opacity blue radial accents.
- Error: pale red mesh with low-opacity red radial accents.
