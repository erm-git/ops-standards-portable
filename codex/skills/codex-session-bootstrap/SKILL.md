---
name: codex-session-bootstrap
description: "Bootstrap new Codex IDE sessions by prompting for CODEX_SESSION_NAME/CODEX_SESSION_ID/CWD and handling later corrections."
---

# Codex Session Bootstrap

## Goal

Collect the minimal session metadata in a consistent block, then pause.

## Steps

1) Reply with the short prompt and the block below, then ask the user to fill it in:

```
CODEX_SESSION_NAME: <project-name>-<next numerical value in series>
CODEX_SESSION_ID: </status thread id of codex chat>
CWD:<current working directory>
```

2) When the user returns the filled block, acknowledge receipt and proceed.
3) If `CODEX_SESSION_ID` is missing, ask only for that value.
4) If the user later posts a correction line like `CODEX_SESSION_NAME: ...`, treat it as the latest label and confirm the update. Keep `CODEX_SESSION_ID` as the authoritative identity.
5) Keep replies short; avoid extra onboarding text.
