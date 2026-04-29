# Backend Gin Patterns

## Server Initialization

Use a predictable startup sequence:

1. Initialize database.
2. Start background tasks.
3. Create Gin router.
4. Configure CORS.
5. Register route groups.
6. Start HTTP server.

Recommended shape:

```go
func main() {
    db.InitDB()
    handlers.StartRetentionTasks()
    handlers.StartSessionTasks()

    r := gin.Default()
    r.Use(cors.New(corsConfig()))

    api := r.Group("/api")
    registerRoutes(api)

    log.Fatal(r.Run(":8888"))
}
```

## CORS Strategy

Use different behavior for development and production.

Development:

- Allow non-standard Tauri/WebView origins.
- Allow loopback variations.
- Prefer `AllowOriginFunc` to reduce local debugging friction.

Production:

- Use a strict allowlist.
- Read public hostnames from environment variables.
- Avoid hardcoded server addresses in reusable code.

Headers commonly needed:

- `Origin`
- `Content-Type`
- `Accept`
- `Authorization`
- `X-Requested-With`
- `Cache-Control`

Expose:

- `Content-Length`
- `Content-Type`

## Route Grouping

Group routes by capability, not by implementation file.

Example:

```text
/api/health
/api/dashboard/*
/api/auth/*
/api/domain/*
/api/ops/*
/api/version/*
/downloads/*
```

Useful groups:

- `public`: health, public download page data, metrics.
- `auth`: login, register, user state.
- `domain`: application/license/device business actions.
- `ops`: audit logs, device logs, sessions, realtime events.
- `version`: release publish/list/sign/download metadata.

For sensitive admin routes, do not rely on route renaming for security. Use real authentication and authorization.

## Handler Style

Handlers should follow a consistent structure:

1. Authenticate or authorize.
2. Bind and validate input.
3. Normalize derived fields.
4. Query or mutate database.
5. Write audit/event records.
6. Return concise JSON.

Example:

```go
func CreateThing(c *gin.Context) {
    var input CreateThingInput
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
        return
    }

    thing := models.Thing{Name: strings.TrimSpace(input.Name)}
    if err := db.DB.Create(&thing).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create"})
        return
    }

    c.JSON(http.StatusCreated, thing)
}
```

## Background Tasks

Start bounded background tasks at startup for:

- retention
- session reconciliation
- periodic stats broadcasts
- backfills
- database maintenance

Rules:

- Never block server startup with long backfills.
- Cap per-run work.
- Use batches and small sleeps to yield the DB connection.
- Log warnings, not fatal errors, for best-effort maintenance.

## Stats Broadcasting

For dashboards, compute simple aggregate stats periodically:

- total users
- active sessions
- today's page views
- total downloads
- unique IPs/devices

Broadcast via an internal event bus or SSE helper rather than coupling dashboard handlers to every write path.

## Error Handling

Use status codes consistently:

- `400`: invalid input.
- `401`: missing/invalid token.
- `403`: authenticated but forbidden.
- `404`: not found.
- `409`: conflict or duplicate active record.
- `500`: unexpected server failure.

Return operator-friendly messages, but avoid leaking secrets or internal file paths.
