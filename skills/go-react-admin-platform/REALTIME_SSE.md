# Realtime SSE

## When To Use SSE

Use Server-Sent Events for lightweight admin realtime updates:

- dashboard stats
- heartbeat events
- log upload notifications
- operational events
- background task progress

Do not use SSE for bidirectional command/control. Use normal POST/PUT endpoints for mutations.

## Backend Event Bus

Use an in-process broadcaster for a single backend instance:

```go
type SystemEvent struct {
    Type      string      `json:"type"`
    Timestamp time.Time   `json:"timestamp"`
    Data      interface{} `json:"data"`
}

type broadcaster struct {
    mu   sync.RWMutex
    subs map[chan SystemEvent]struct{}
}
```

Subscribers get buffered channels:

```go
ch := make(chan SystemEvent, 64)
```

Broadcast should never block:

```go
select {
case ch <- event:
default:
    // Drop event for slow client.
}
```

This protects the server when one browser tab stalls.

## SSE Handler

Set headers:

```go
w.Header().Set("Content-Type", "text/event-stream")
w.Header().Set("Cache-Control", "no-cache")
w.Header().Set("Connection", "keep-alive")
w.Header().Set("X-Accel-Buffering", "no")
```

Flush:

- an initial comment
- periodic keepalive comments
- every event

Example event:

```text
event: STATS_UPDATE
data: {"type":"STATS_UPDATE","timestamp":"...","data":{...}}
```

## Keepalive

Send keepalive comments every 30 seconds:

```text
: keepalive
```

This prevents reverse proxies and browsers from assuming the stream is dead.

## Frontend API

Centralize SSE creation:

```ts
streamSystemEvents(onEvent: (event: { type: string; data: any }) => void) {
  const es = new EventSource(`${API_BASE_URL}/ops/system/events`);
  // register handlers
  return () => es.close();
}
```

## Reconnect Logic

Use exponential backoff:

```ts
const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
```

Cap attempts to avoid infinite tight retry loops.

Reset attempts after a successful message or `open` event.

## React Context

Open one SSE connection in a provider:

```tsx
<SystemEventsProvider>
  <Layout>{children}</Layout>
</SystemEventsProvider>
```

Expose:

- `isConnected`
- `latestStats`
- `lastEvent`

Feature hooks can subscribe to context changes instead of creating new EventSource connections.

## Deduplication

React state updates can cause the same event to be observed more than once by feature hooks. Deduplicate with:

```ts
const eventKey = `${lastEvent.type}-${lastEvent.timestamp}`;
```

Use real IDs when events have them.

## Production Notes

- Disable proxy buffering for SSE.
- Keep payloads small.
- Do not send secrets over SSE.
- Do not rely on SSE for guaranteed delivery.
- If horizontal scaling is needed, replace the in-process bus with Redis pub/sub or a message broker.
