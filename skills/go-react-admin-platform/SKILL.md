---
name: go-react-admin-platform
description: Design, implement, and maintain full-stack admin platforms with a Go/Gin/GORM backend, SQLite or small relational database, React/Vite frontend, realtime SSE updates, file uploads/downloads, audit logs, retention jobs, and Docker deployment.
---

# Go React Admin Platform

## When To Use

Use this skill when building or refactoring a production-oriented web management platform with:

- Go backend using Gin-style HTTP routing.
- GORM models with SQLite or another relational database.
- React/Vite/TypeScript admin frontend.
- Dashboard metrics, audit logs, device/user/license/application management, or release management.
- Server-sent events for lightweight realtime updates.
- File upload/download flows with checksums or signed access.
- Docker Compose deployment with backend and frontend containers.

## Core Shape

The reference architecture is:

```text
React/Vite frontend
  -> typed API client
  -> /api grouped backend routes
  -> Go/Gin handlers
  -> GORM models
  -> SQLite or relational DB
  -> background jobs for retention/backfill/stats
```

Keep the system boring in the right places:

- Backend owns validation, persistence, audit, and file safety.
- Frontend owns navigation, state presentation, i18n, and operator workflows.
- Database models are explicit and indexed around lookup paths.
- Background jobs are bounded, batched, and non-blocking.
- Deployment is environment-driven, not hardcoded.

## Reference Files

Read the focused reference before editing:

- [BACKEND_GIN.md](BACKEND_GIN.md)
- [DATABASE_GORM_SQLITE.md](DATABASE_GORM_SQLITE.md)
- [FRONTEND_REACT_VITE.md](FRONTEND_REACT_VITE.md)
- [REALTIME_SSE.md](REALTIME_SSE.md)
- [FILES_RELEASES_AUDIT.md](FILES_RELEASES_AUDIT.md)
- [DEPLOYMENT_DOCKER.md](DEPLOYMENT_DOCKER.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Implementation Workflow

1. Define domain entities first: users, applications, licenses, versions, logs, sessions, stats, or equivalent.
2. Add GORM models with JSON fields, indexes, unique constraints, and soft-delete only where useful.
3. Initialize database from an environment-controlled path and run migrations at startup.
4. Build route groups by capability: public, auth, domain, ops/admin, versions/releases.
5. Keep handlers thin enough to reason about; extract helpers for signing, hashing, retention, and event broadcasting.
6. Build a frontend API layer that normalizes base URL and auth headers.
7. Put React routing and protected layouts around feature modules.
8. Use SSE only for operational realtime updates; keep polling or explicit fetch for slower data.
9. Add retention/backfill tasks for high-volume logs and long-lived SQLite deployments.
10. Deploy with Docker volumes for database and uploaded files.

## Non-Negotiables

- Do not commit real tokens, server IPs, passwords, private keys, or production bearer secrets.
- Do not hardcode deployment hostnames in reusable code; use env vars and build args.
- Do not let background jobs monopolize SQLite; batch work and sleep between batches.
- Do not stream realtime events without keepalive and client reconnection logic.
- Do not return large file content in list APIs; expose content/download endpoints separately.
- Do not rely on frontend auth checks alone for sensitive backend operations.

## Verification Checklist

- Backend health endpoint works.
- Database initializes and migrates from a configurable path.
- CORS behavior differs between dev and production.
- API base URL works with both explicit `VITE_API_URL` and same-origin deployments.
- Docker volumes persist database and uploaded files.
- SSE reconnects after temporary disconnects.
- Retention tasks keep logs bounded.
- Frontend build and lint pass.
