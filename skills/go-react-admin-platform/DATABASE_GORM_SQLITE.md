# Database GORM SQLite Patterns

## Database Path

Read the database path from an environment variable:

```go
dbPath := os.Getenv("APP_DB_PATH")
if dbPath == "" {
    dbPath = "app.db"
}
```

Before opening SQLite, ensure the parent directory exists:

```go
dbDir := filepath.Dir(dbPath)
if dbDir != "." && dbDir != "" {
    _ = os.MkdirAll(dbDir, 0755)
}
```

This makes local, Docker, and mounted-volume deployments use the same code path.

## SQLite Runtime Settings

For small admin platforms, SQLite is viable when configured carefully.

Use:

```go
sqlDB.SetMaxOpenConns(1)
sqlDB.Exec("PRAGMA journal_mode=WAL;")
sqlDB.Exec("PRAGMA busy_timeout=5000;")
```

Why:

- `SetMaxOpenConns(1)` reduces `database is locked` errors.
- WAL improves concurrent read/write behavior.
- `busy_timeout` allows short waits instead of immediate failure.

## Auto Migration

Run migrations at startup for small internal platforms:

```go
db.AutoMigrate(
    &models.User{},
    &models.Application{},
    &models.Version{},
    &models.AuditLog{},
    &models.DeviceLog{},
    &models.DeviceSession{},
    &models.DeviceStats{},
)
```

For larger public products, migrate to explicit migration files. For internal admin systems, `AutoMigrate` is often enough when schema changes are additive and reviewed.

## Model Design

Use models that reflect operational workflows:

- `User`: identity, status, role flags.
- `Application`: approval workflow or request lifecycle.
- `License` or entitlement: device binding, status, permissions.
- `Version`: release metadata and download counters.
- `AuditLog`: operator actions.
- `Telemetry`: heartbeat or client reports.
- `PageView`: public portal metrics.
- `DeviceLog`: uploaded file metadata.
- `DeviceSession`: session boundaries and duration.
- `DeviceStats`: long-term aggregates.

## Indexing Rules

Index lookup paths:

- unique employee/user id
- hardware/device id
- license key or entitlement key
- version + platform
- timestamps used by retention or dashboards
- session start/end time

Example:

```go
Version  string `gorm:"not null;index:idx_version_platform,unique"`
Platform string `gorm:"not null;index:idx_version_platform,unique"`
```

## Large Text And File Content

Do not return large content in list APIs.

Pattern:

- store metadata in list rows
- store file content in a separate text column or file
- expose detail endpoint for content
- expose download endpoint for binary/file transfer

Example:

```go
Content string `gorm:"type:text" json:"-"`
```

## Backfills

Backfills should run in background:

- cap total records per run
- use batches
- sleep briefly between batches
- skip missing files
- skip compressed files if content is read on demand

This keeps health checks and API requests responsive during startup.

## Retention

Retention should protect both database and disk:

1. Delete old rows by age.
2. Delete associated files.
3. Cap max rows for high-volume tables.
4. Sleep between batches.
5. Run `VACUUM` occasionally to reclaim SQLite space.

Keep retention settings environment-driven:

```text
APP_LOG_RETENTION_DAYS=7
APP_LOG_RETENTION_MAX_LOGS=10000
```

## Vacuum

SQLite `VACUUM` can take time. Run it:

- in background
- infrequently
- outside heavy write windows
- with warning logs on failure
