---
title: "Secrets Standards"
status: "standard"
---

## Goals

- Keep secrets out of git history (no plaintext commits).
- Keep secrets in one predictable place.
- Keep operational docs free of secret values.

## Portable baseline

- Secrets root: `$HOME/.config/secrets/`
- Each service gets a directory under that root.
- Store only encrypted payloads (tooling choice is host-specific).
