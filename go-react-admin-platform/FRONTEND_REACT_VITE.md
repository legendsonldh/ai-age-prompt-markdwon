# Frontend React Vite Patterns

## App Shape

Use React/Vite/TypeScript for the admin frontend.

Recommended layers:

```text
src/
  api.ts
  App.tsx
  main.tsx
  components/
  components/ui/
  context/
  hooks/
  locales/
  types/
  config/
```

## Routing

Use public routes and protected admin routes:

```tsx
<Routes>
  <Route path="/" element={<Home />} />
  <Route path="/download" element={<PublicDownload />} />
  <Route path="/login" element={<Login />} />
  <Route
    path="/dashboard/*"
    element={
      <ProtectedRoute>
        <Dashboard />
      </ProtectedRoute>
    }
  />
  <Route path="*" element={<Navigate to="/" replace />} />
</Routes>
```

Frontend route protection improves UX, but backend authorization is still required for sensitive operations.

## Layout

Use one shell layout:

- global navbar
- centered responsive container
- animated page body
- footer with build metadata
- theme and realtime providers above layout

For admin dashboards, prefer:

- sidebar on desktop
- drawer on mobile
- feature modules mounted through nested routes
- explicit `navItems` array that drives both nav and page title

## API Client

Centralize API access in `api.ts`.

Base URL rules:

1. Prefer `VITE_API_URL` when set.
2. Normalize host-only input to include `/api`.
3. In production, fallback to same-origin `/api` so reverse proxy deployments work.
4. Keep localhost fallback only for rare non-browser contexts.

Example:

```ts
function normalizeApiBaseUrl(input: string): string {
  const trimmed = input.replace(/\/+$/, '');
  if (trimmed.endsWith('/api')) return trimmed;
  return `${trimmed}/api`;
}

function resolveApiBaseUrl(): string {
  const fromEnv = import.meta.env.VITE_API_URL as string | undefined;
  if (fromEnv && fromEnv.trim()) return normalizeApiBaseUrl(fromEnv.trim());
  if (typeof window !== 'undefined' && window.location?.origin) {
    return `${window.location.origin}/api`;
  }
  return 'http://localhost:8888/api';
}
```

## Auth Headers

Use a small helper:

```ts
export const withAuth = (headers: Record<string, string> = {}) => {
  const token = localStorage.getItem('authToken');
  if (!token) return headers;
  return { ...headers, Authorization: `Bearer ${token}` };
};
```

Do not scatter token reads across every component.

## Feature Modules

Make each admin capability a module:

- applications/approvals
- users/licenses/entitlements
- downloads/releases
- monitoring
- logs
- database view
- device assets

Each module should own:

- fetch function calls
- local loading/error state
- table/card rendering
- user actions

Shared UI components should stay under `components/ui`.

## Realtime Integration

Use a context provider for realtime data:

- one SSE connection
- shared connection state
- latest stats
- last event

Use hooks to convert events into feature callbacks. This avoids opening multiple EventSource connections per component.

## i18n

Put operator text in locale files:

- navigation labels
- button labels
- status labels
- table headings
- errors where practical

Keep release/build metadata separate from translation files when it is generated at build time.

## Build Metadata

Expose build info in the footer or system panel:

- frontend version
- build time
- commit hash if available

This helps operators confirm what is deployed without checking the server.

## UX Principles

- Show connection/system status in the admin shell.
- Keep destructive actions visually distinct.
- Prefer compact cards and tables for operator workflows.
- Use empty states and loading states consistently.
- Avoid hiding operational errors behind generic toast messages only.
