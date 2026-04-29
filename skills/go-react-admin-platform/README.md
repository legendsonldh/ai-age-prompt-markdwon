# Go React Admin Platform

Reusable Skill and references for building internal admin platforms with Go/Gin/GORM backends and React/Vite frontends.

## Documents

- [SKILL.md](SKILL.md): Agent-facing entry point and workflow.
- [BACKEND_GIN.md](BACKEND_GIN.md): Gin server setup, CORS, route grouping, handler style, and background jobs.
- [DATABASE_GORM_SQLITE.md](DATABASE_GORM_SQLITE.md): SQLite/GORM setup, models, indexes, retention, backfills, and vacuum.
- [FRONTEND_REACT_VITE.md](FRONTEND_REACT_VITE.md): React routing, layout, API client, auth headers, modules, i18n, and build metadata.
- [REALTIME_SSE.md](REALTIME_SSE.md): Backend event bus, SSE streaming, frontend reconnect, and React context.
- [FILES_RELEASES_AUDIT.md](FILES_RELEASES_AUDIT.md): Uploads, checksums, release records, signed downloads, audit logs, and retention.
- [DEPLOYMENT_DOCKER.md](DEPLOYMENT_DOCKER.md): Docker Compose shape, volumes, health checks, frontend API config, and deployment safety.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): Common backend, database, frontend, SSE, and deployment failures.

## Intended Use

Use this series when building a compact but production-aware admin system:

- internal management portal
- release/download platform
- license or entitlement console
- device/user operations dashboard
- log and telemetry viewer
- small business operations backend

The patterns are intentionally generic and should not depend on any single project name, server IP, token, or deployment host.
