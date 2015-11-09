# `embedded-agents`

```
+--------------+ +---------------+
|      IO      | | Target (main) |
+--------------+ +---------------+
  enque(msg) -----> on('msg') // while running
                    msg = poll() // while paused
  dispatch(msg) <-- enque(msg)
```

1. Never parse messages in IO thread
2. Transfer line-by-line to main thread
3. Have smart logic that manages the queue polling
