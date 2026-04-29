# Deployment Docker

## Compose Shape

Use two containers:

- backend API container
- frontend static/Vite container or nginx container

Recommended shape:

```yaml
services:
  backend:
    build:
      context: ./server
      dockerfile: Dockerfile
    ports:
      - "${BACKEND_HOST_PORT:-8889}:8888"
    environment:
      - APP_DB_PATH=/app/data/app.db
      - GIN_MODE=release
      - APP_LOG_RETENTION_DAYS=7
      - APP_LOG_RETENTION_MAX_LOGS=10000
    volumes:
      - ./server/data:/app/data
      - ./server/uploads:/app/uploads
    restart: unless-stopped

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      args:
        - VITE_API_URL=${PUBLIC_API_URL}
    depends_on:
      - backend
    restart: unless-stopped
```

Do not hardcode production IPs in shared Docker examples.

## Persistent Volumes

Persist:

- SQLite database
- uploaded files
- generated release files
- logs when needed

Do not store persistent data only inside container layers.

## Health Checks

Backend should expose:

```text
GET /api/health
```

Docker healthcheck example:

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8888/api/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## Frontend API Configuration

Support both:

- build-time `VITE_API_URL`
- same-origin `/api` reverse proxy deployments

This lets the same frontend work in:

- local Vite dev
- direct Docker port exposure
- nginx reverse proxy
- domain-based production deployment

## Resource Limits

For small internal admin systems, set conservative backend limits:

```yaml
deploy:
  resources:
    limits:
      cpus: "1.0"
      memory: 512M
    reservations:
      memory: 128M
```

SQLite and log processing benefit from predictable memory usage.

## CORS In Deployment

Production CORS should read allowed public host/IP from environment variables.

Avoid fallback hardcoded IPs. Prefer:

```text
APP_PUBLIC_HOST=example.com
APP_PUBLIC_PORT=5174
```

or use same-origin proxying and avoid cross-origin requests entirely.

## Deployment Safety

- Back up SQLite before backend schema or retention changes.
- Back up upload/release directories before cleanup scripts.
- Keep secrets in environment or private deployment config.
- Never commit real bearer tokens, admin passwords, or server addresses in public references.
- Verify containers with `docker compose ps`.
- Verify health endpoint after rollout.
