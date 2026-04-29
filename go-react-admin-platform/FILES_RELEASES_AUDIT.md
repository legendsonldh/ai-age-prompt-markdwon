# Files Releases Audit

## File Uploads

For uploaded logs or assets, store both file metadata and safe server-side paths.

Model fields:

- original client filename
- server-assigned filename
- stored file path
- file size
- file type/category
- upload source IP
- associated user/device/license id
- created timestamp

Do not trust client filenames for filesystem paths.

## File Content

For logs:

- Keep list APIs lightweight.
- Store content separately or hide it from JSON list responses.
- Expose `GET /content` for text content.
- Expose `GET /download` for file transfer.

Pattern:

```go
Content string `gorm:"type:text" json:"-"`
```

## Checksums

For release files, calculate SHA-256 and store it with the version row.

Use checksums for:

- integrity display
- client verification
- backfilling old release records
- signed download metadata

Backfill missing checksums in the background so startup is not blocked.

## Release Model

A release/version table should support the same semantic version across platforms.

Recommended unique key:

```text
version + platform
```

Fields:

- semantic version
- platform
- status
- file name
- file size
- file path
- SHA-256
- description
- force-update flag
- download count
- release date

## Signed Downloads

For private or controlled downloads:

- Store files outside public static directories.
- Generate signed URLs or signed download requests.
- Verify signature and expiry before serving files.
- Increment download counters server-side.

Avoid embedding permanent direct file URLs in clients.

## Audit Logs

Create audit records for important state changes:

- application submitted
- application approved/rejected
- license revoked
- permissions updated
- release published
- release deleted
- download signed or served
- access-control changes

Audit fields:

- actor user id
- action
- target
- IP
- location if available
- structured details
- timestamp

Use JSON details when the action has multiple attributes.

## Public Metrics

For public pages:

- track page views
- track user agent and IP if needed
- index created time
- aggregate by day for dashboard stats

Keep this simple unless product analytics are a first-class requirement.

## Retention

High-volume logs need retention by age and count.

Rules:

- Delete DB rows and associated files together.
- Use batches.
- Keep newest records when applying count caps.
- Do not load all paths into memory.
- Sleep briefly between batches.
