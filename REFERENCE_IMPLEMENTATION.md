# Reference Implementation

This file captures the original UI style that inspired the Tauri Apple Glass UI language.

Use it as a concrete implementation sample, not as a strict requirement. New projects can copy these tokens and utilities directly, then adjust naming, spacing, and semantics to fit their product.

## Source Shape

The reference implementation is built around:

- Tauri desktop shell.
- React components.
- Tailwind CSS tokens.
- A small `index.css` utility layer.
- Light-mode-only Apple glass styling.
- Compact dashboard, tray, modal, and card surfaces.

## Tailwind Token Set

The core palette uses Apple Blue, Apple gray, translucent glass colors, soft shadows, large radii, and simple entry animations.

```js
colors: {
  primary: {
    50: '#f0f7ff',
    100: '#e0effe',
    200: '#bae0fd',
    300: '#7cc8fb',
    400: '#38acf7',
    500: '#007AFF',
    600: '#0066CC',
    700: '#0052A3',
    800: '#003D7A',
    900: '#002952',
    950: '#001429',
  },
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

```js
borderRadius: {
  xl: '1rem',
  '2xl': '1.25rem',
  '3xl': '1.5rem',
  '4xl': '2rem',
  apple: '1.25rem',
}
```

```js
boxShadow: {
  apple: '0 8px 30px rgba(0, 0, 0, 0.04)',
  'apple-hover': '0 14px 40px rgba(0, 0, 0, 0.08)',
  'apple-active': '0 4px 12px rgba(0, 0, 0, 0.06)',
  glass: '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
  'inner-light': 'inset 0 1px 1px rgba(255, 255, 255, 0.4)',
}
```

```js
backdropBlur: {
  xs: '2px',
  md: '12px',
  lg: '20px',
  xl: '40px',
}
```

```js
animation: {
  'fade-in': 'fadeIn 0.6s ease-out forwards',
  'slide-up': 'slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards',
  'scale-in': 'scaleIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards',
  'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
}
```

## Base CSS

The body uses a platform-native font stack and transparent background so Tauri windows can control their own surface.

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

Tray mode forces a transparent page and locks overflow:

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

.tray-mode-root {
  background: transparent !important;
  background-color: transparent !important;
  width: 100vw !important;
  height: 100vh !important;
  display: flex !important;
  align-items: flex-start !important;
  justify-content: center !important;
  padding: 10px !important;
}
```

## Glass Utility Layer

The central surface primitive is `glass-panel`.

```css
.glass-panel {
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
}

.glass-panel-hover {
  transition: all 0.3s ease-out;
}

.glass-panel-hover:hover {
  background-color: #ffffff;
  transform: scale(1.02);
  box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
  border-color: rgba(255, 255, 255, 1);
}
```

The heavier reusable card utility adds bigger radius and a more physical hover.

```css
.card {
  background-color: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
  border-radius: 2rem;
  transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
}

.card:hover {
  background-color: #ffffff;
  box-shadow: 0 14px 40px rgba(0, 0, 0, 0.1);
  border-color: rgba(255, 255, 255, 0.9);
  transform: translateY(-4px) scale(1.01);
}
```

## Buttons And Inputs

Primary buttons use Apple Blue, rounded geometry, hover lift, and active compression.

```css
.btn-primary {
  background-color: #007AFF;
  color: #ffffff;
  font-weight: 600;
  letter-spacing: 0.025em;
  border-radius: 0.75rem;
  padding: 0.875rem 2rem;
  transition: all 0.3s ease-out;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}

.btn-primary:hover {
  background-color: #0062cc;
  transform: translateY(-2px);
}

.btn-primary:active {
  transform: scale(0.98);
  box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.06);
}
```

Secondary buttons stay translucent and quiet until hover.

```css
.btn-secondary {
  background-color: rgba(255, 255, 255, 0.8);
  color: #86868B;
  font-weight: 600;
  letter-spacing: 0.025em;
  border-radius: 0.75rem;
  padding: 0.875rem 2rem;
  backdrop-filter: blur(12px);
  border: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease-out;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}

.btn-secondary:hover {
  background-color: #ffffff;
  color: #1D1D1F;
  transform: translateY(-2px);
}
```

Inputs use translucent fills and a luminous blue focus ring.

```css
.input-field {
  background-color: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(12px);
  color: #1D1D1F;
  border-radius: 0.75rem;
  padding: 1rem 1.25rem;
  border: 1px solid transparent;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease-out;
}

.input-field:focus {
  outline: none;
  background-color: #ffffff;
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.3), 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}
```

## Mesh Backgrounds

The background is a soft material layer, with variants for normal, active, and error states.

```css
.mesh-gradient {
  background-color: #f5f5f7;
  background-image:
    radial-gradient(at 0% 0%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(200, 220, 255, 0.4) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 0% 100%, rgba(230, 240, 255, 0.5) 0px, transparent 50%);
  transition: all 1s cubic-bezier(0.4, 0, 0.2, 1);
}

.mesh-gradient-connected {
  background-color: #e6f1ff;
  background-image:
    radial-gradient(at 0% 0%, rgba(255, 255, 255, 0.9) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(0, 122, 255, 0.15) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 0% 100%, rgba(0, 122, 255, 0.1) 0px, transparent 50%);
}

.mesh-gradient-error {
  background-color: #fff5f5;
  background-image:
    radial-gradient(at 0% 0%, rgba(255, 255, 255, 0.9) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(255, 59, 48, 0.1) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(255, 255, 255, 0.8) 0px, transparent 50%),
    radial-gradient(at 0% 100%, rgba(255, 59, 48, 0.05) 0px, transparent 50%);
}
```

## App Shell Recipe

The main shell combines full-screen mesh, hidden overflow, platform text styling, and long state transitions.

```tsx
<div className={`h-screen mesh-gradient bg-white ${isActive ? 'mesh-gradient-connected' : hasError ? 'mesh-gradient-error' : ''} overflow-hidden font-sans text-apple-gray-500 selection:bg-apple-blue/20 selection:text-apple-blue transition-all duration-1000`}>
  {children}
</div>
```

## Service Card Recipe

The service card is a layered glass object: full-card hit area, absolute glass backing, floating status chip, icon tile, and compact text.

```tsx
<div className="group relative h-48 flex flex-col items-center justify-center cursor-pointer will-change-transform">
  <div className="absolute inset-0 glass-panel rounded-2xl transition-all duration-500 group-hover:scale-[1.02] group-hover:shadow-apple-hover group-hover:bg-white/80 border border-white/50 group-hover:border-white/90" />

  <div className="absolute top-4 right-4 z-10 flex items-center gap-2 px-2.5 py-1 bg-white/50 backdrop-blur-md rounded-full border border-white/60 shadow-sm transition-all duration-300 group-hover:bg-white/80 group-hover:shadow-md">
    <div className="w-1.5 h-1.5 rounded-full bg-green-500 shadow-[0_0_6px_rgba(34,197,94,0.6)]" />
    <span className="text-[9px] font-bold uppercase tracking-widest text-green-600/90">
      online
    </span>
  </div>

  <div className="relative z-10 flex flex-col items-center gap-4 p-4 transition-transform duration-500 group-hover:-translate-y-0.5">
    <div className="w-14 h-14 rounded-xl flex items-center justify-center bg-gradient-to-br from-white to-apple-gray-50 border border-white/60 shadow-md shadow-apple-gray-200/10 transition-all duration-500 group-hover:shadow-xl group-hover:shadow-apple-blue/15 group-hover:scale-105 group-hover:border-apple-blue/5">
      <div className="text-apple-gray-300 group-hover:text-apple-blue transition-colors duration-500 scale-90">
        icon
      </div>
    </div>

    <div className="text-center space-y-1.5">
      <h3 className="text-lg font-bold text-apple-gray-500 group-hover:text-black transition-colors duration-300 tracking-tight">
        Title
      </h3>
      <p className="text-[11px] text-apple-gray-400/80 font-medium leading-relaxed max-w-[160px] mx-auto tracking-wide group-hover:text-apple-gray-400 transition-colors duration-300">
        Short description
      </p>
    </div>
  </div>
</div>
```

## Tray Popup Recipe

The tray is a single compact glass capsule with profile, metrics, shortcuts, segmented choices, and primary actions.

```tsx
<div className="w-full h-full flex flex-col items-center bg-transparent overflow-hidden">
  <div className="w-[292px] bg-white/95 backdrop-blur-2xl rounded-[2.5rem] border border-white/40 shadow-[0_20px_50px_rgba(0,0,0,0.15)] flex flex-col font-sans ring-1 ring-black/5 overflow-hidden animate-in fade-in zoom-in duration-300">
    <div className="px-7 pt-7 pb-4 bg-gradient-to-br from-apple-blue/5 to-transparent">
      <div className="flex items-center gap-4">
        <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-apple-blue to-[#4096ff] flex items-center justify-center text-white font-bold text-xl shadow-lg shadow-apple-blue/20">
          U
        </div>
        <div className="flex flex-col">
          <span className="text-base font-bold text-gray-800 leading-tight">User</span>
          <div className="flex items-center gap-1.5 mt-0.5">
            <span className="text-[10px] text-gray-400 font-bold tracking-widest uppercase">ID-0000</span>
            <div className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" />
          </div>
        </div>
      </div>
    </div>

    <div className="px-6 pb-6 pt-2">
      <div className="bg-gray-50/50 rounded-[1.8rem] p-5 border border-gray-200/30">
        <div className="flex justify-between items-end mb-4">
          <span className="text-[9px] font-black text-gray-400 uppercase tracking-[0.2em] leading-none">
            stats
          </span>
          <span className="text-[9px] font-bold px-2 py-0.5 rounded-full bg-green-100 text-green-700">
            ACTIVE
          </span>
        </div>

        <div className="flex items-center justify-between gap-4">
          <div className="flex flex-col flex-1">
            <span className="text-[9px] text-gray-400 font-bold uppercase">upload</span>
            <span className="text-lg font-mono font-bold text-gray-700 tracking-tight">0 KB/s</span>
          </div>
          <div className="w-[1px] h-8 bg-gray-200/50" />
          <div className="flex flex-col flex-1">
            <span className="text-[9px] text-gray-400 font-bold uppercase">download</span>
            <span className="text-lg font-mono font-bold text-apple-blue tracking-tight">0 KB/s</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

## Modal Recipe

Reference modals use a dark translucent overlay, a glass body, optional blue orb, tight title, and border-separated footer.

```tsx
<div className="fixed inset-0 z-50 flex items-center justify-center p-8 bg-black/60 backdrop-blur-md animate-fade-in">
  <div className="glass-panel rounded-[2rem] max-w-lg w-full p-8 animate-slide-up relative overflow-hidden">
    <div className="absolute -top-32 -right-32 w-48 h-48 bg-apple-blue/10 rounded-full blur-3xl pointer-events-none" />

    <div className="flex items-center justify-between mb-6 relative z-10">
      <h2 className="text-2xl font-bold text-apple-gray-500 tracking-tight">
        Settings
      </h2>
      <button className="w-9 h-9 rounded-lg hover:bg-apple-gray-50 text-apple-gray-400 hover:text-apple-gray-500 transition-all flex items-center justify-center">
        x
      </button>
    </div>

    <div className="space-y-6 relative z-10">
      {content}
    </div>

    <div className="mt-8 pt-6 border-t border-black/5 flex justify-end">
      <button className="btn-primary px-8 py-3 rounded-lg text-sm font-bold uppercase tracking-wide">
        Close
      </button>
    </div>
  </div>
</div>
```

## Floating Controls Recipe

Floating buttons are round glass affordances for help, language, or compact global actions.

```tsx
<div className="fixed bottom-8 left-8 z-50 flex flex-col gap-3">
  <button className="w-12 h-12 flex items-center justify-center rounded-full glass-panel bg-white/70 backdrop-blur-md border border-white/20 shadow-lg hover:scale-110 active:scale-95 transition-all duration-300 group">
    <span className="text-[11px] font-black text-apple-gray-400 group-hover:text-apple-blue tracking-tighter transition-colors">
      ZH
    </span>
  </button>
</div>
```

## Scrollbar

The scrollbar is intentionally subtle and macOS-like.

```css
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.15);
  border-radius: 99px;
  transition: background 0.3s;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.25);
}
```
