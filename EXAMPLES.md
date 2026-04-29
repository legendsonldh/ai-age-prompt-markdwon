# Examples

## App Shell

```tsx
export function AppShell({ state, children }: { state: 'neutral' | 'active' | 'error'; children: React.ReactNode }) {
  const stateClass =
    state === 'active'
      ? 'mesh-gradient-active'
      : state === 'error'
        ? 'mesh-gradient-error'
        : 'mesh-gradient';

  return (
    <div className={`h-screen ${stateClass} overflow-hidden font-sans text-apple-gray-500 selection:bg-apple-blue/20 selection:text-apple-blue transition-all duration-1000`}>
      {children}
    </div>
  );
}
```
## Primary Panel

```tsx
export function PrimaryPanel({ children }: { children: React.ReactNode }) {
  return (
    <div className="glass-panel rounded-[2rem] border border-white/40 shadow-sm">
      {children}
    </div>
  );
}
```

## Status Chip

```tsx
type StatusChipProps = {
  status: 'online' | 'offline' | 'checking';
  label: string;
};

export function StatusChip({ status, label }: StatusChipProps) {
  const tone = {
    online: {
      dot: 'bg-green-500 shadow-[0_0_6px_rgba(34,197,94,0.6)]',
      text: 'text-green-600/90',
    },
    offline: {
      dot: 'bg-red-500 shadow-[0_0_6px_rgba(239,68,68,0.6)]',
      text: 'text-red-500',
    },
    checking: {
      dot: 'bg-apple-gray-300 animate-pulse',
      text: 'text-apple-gray-400',
    },
  }[status];

  return (
    <div className="flex items-center gap-2 px-2.5 py-1 bg-white/50 backdrop-blur-md rounded-full border border-white/60 shadow-sm">
      <div className={`w-1.5 h-1.5 rounded-full transition-all duration-500 ${tone.dot}`} />
      <span className={`text-[9px] font-bold uppercase tracking-widest ${tone.text}`}>
        {label}
      </span>
    </div>
  );
}
```

## Service Card

```tsx
export function ServiceCard({
  title,
  description,
  status,
  icon,
  onClick,
}: {
  title: string;
  description: string;
  status: React.ReactNode;
  icon: React.ReactNode;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className="group relative h-48 flex flex-col items-center justify-center cursor-pointer text-left will-change-transform"
    >
      <div className="absolute inset-0 glass-panel rounded-2xl transition-all duration-500 group-hover:scale-[1.02] group-hover:shadow-apple-hover group-hover:bg-white/80 border border-white/50 group-hover:border-white/90" />
      <div className="absolute top-4 right-4 z-10">{status}</div>
      <div className="relative z-10 flex flex-col items-center gap-4 p-4 transition-transform duration-500 group-hover:-translate-y-0.5">
        <div className="w-14 h-14 rounded-xl flex items-center justify-center bg-gradient-to-br from-white to-apple-gray-50 border border-white/60 shadow-md shadow-apple-gray-200/10 transition-all duration-500 group-hover:shadow-xl group-hover:shadow-apple-blue/15 group-hover:scale-105 group-hover:border-apple-blue/5">
          <div className="text-apple-gray-300 group-hover:text-apple-blue transition-colors duration-500 scale-90">
            {icon}
          </div>
        </div>
        <div className="text-center space-y-1.5">
          <h3 className="text-lg font-bold text-apple-gray-500 group-hover:text-black transition-colors duration-300 tracking-tight">
            {title}
          </h3>
          <p className="text-[11px] text-apple-gray-400/80 font-medium leading-relaxed max-w-[160px] mx-auto tracking-wide group-hover:text-apple-gray-400 transition-colors duration-300">
            {description}
          </p>
        </div>
      </div>
    </button>
  );
}
```

## Modal

```tsx
export function GlassModal({
  title,
  children,
  footer,
  onClose,
}: {
  title: string;
  children: React.ReactNode;
  footer: React.ReactNode;
  onClose: () => void;
}) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-8 bg-black/60 backdrop-blur-md animate-fade-in">
      <div className="glass-panel rounded-[2rem] max-w-lg w-full p-8 animate-slide-up relative overflow-hidden">
        <div className="absolute -top-32 -right-32 w-48 h-48 bg-apple-blue/10 rounded-full blur-3xl pointer-events-none" />
        <div className="flex items-center justify-between mb-6 relative z-10">
          <h2 className="text-2xl font-bold text-apple-gray-500 tracking-tight">{title}</h2>
          <button
            onClick={onClose}
            className="w-9 h-9 rounded-lg hover:bg-apple-gray-50 text-apple-gray-400 hover:text-apple-gray-500 transition-all flex items-center justify-center"
          >
            ×
          </button>
        </div>
        <div className="relative z-10">{children}</div>
        <div className="mt-8 pt-6 border-t border-black/5 flex justify-end">
          {footer}
        </div>
      </div>
    </div>
  );
}
```

## Floating Button

```tsx
export function FloatingGlassButton({ children, onClick }: { children: React.ReactNode; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="w-12 h-12 flex items-center justify-center rounded-full glass-panel bg-white/70 backdrop-blur-md border border-white/20 shadow-lg hover:scale-110 active:scale-95 transition-all duration-300 group"
    >
      {children}
    </button>
  );
}
```

## Metric Block

```tsx
export function MetricBlock({ label, value, accent = false }: { label: string; value: string; accent?: boolean }) {
  return (
    <div className="flex flex-col">
      <span className="text-[9px] text-apple-gray-400 font-bold uppercase tracking-widest">
        {label}
      </span>
      <span className={`text-lg font-mono font-bold tracking-tight ${accent ? 'text-apple-blue' : 'text-apple-gray-500'}`}>
        {value}
      </span>
    </div>
  );
}
```
