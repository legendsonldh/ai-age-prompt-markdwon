# Troubleshooting

## Backend Starts But API Fails

Check:

- database path exists and parent directory is writable
- migrations succeeded
- container volume is mounted
- `GIN_MODE` and CORS mode are expected
- backend port mapping is correct

Common fix:

```bash
curl http://localhost:8888/api/health
```

## SQLite Database Is Locked

Symptoms:

- intermittent write failures
- health endpoint slow during cleanup
- logs mention `database is locked`

Fix:

- set max open connections to 1
- enable WAL
- set busy timeout
- batch background jobs
- sleep between retention batches
- avoid long transactions in handlers

## Frontend Cannot Reach Backend

Check:

- `VITE_API_URL`
- whether API base includes `/api`
- same-origin fallback behavior
- Docker port mapping
- CORS allowlist
- reverse proxy `/api` rule

Base URL normalization should accept both:

```text
https://example.com
https://example.com/api
```

## SSE Disconnects Frequently

Check:

- response has `Content-Type: text/event-stream`
- proxy buffering disabled
- keepalive comments sent periodically
- frontend reconnect backoff
- browser devtools network tab

For nginx, disable buffering for SSE routes.

## Logs Grow Too Fast

Fix:

- add retention by age
- add retention by max count
- delete associated files and DB rows
- run cleanup at startup and periodically
- cap startup backfills

## File Downloads Fail

Check:

- file exists on disk
- path is not from untrusted client input
- signed URL has not expired
- signature verification matches server secret
- content type is acceptable
- download counter update does not block serving

## Dashboard Counts Are Wrong

Check:

- aggregation queries match model semantics
- active window duration is correct
- timezone/day boundary is correct
- soft-deleted records are intended to be excluded
- realtime stats event matches REST stats endpoint

## Frontend Shows Old Build

Check:

- Docker image rebuilt
- frontend build args changed
- browser cache
- build info generated at build time
- correct container is running

## Deployment Accidentally Uses Dev CORS

Symptoms:

- any origin can call production API

Fix:

- ensure production environment does not set dev-CORS override
- set explicit allowed public host
- prefer same-origin reverse proxy for public deployments
