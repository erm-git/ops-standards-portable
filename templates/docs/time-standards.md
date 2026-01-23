---
title: "Time Standards"
status: "standard"
---

## Goals

- Keep time synchronized across hosts.
- Prefer NTP/chrony/systemd-timesyncd depending on distro.

## Practical baseline

- Enable time sync.
- Use at least 2 upstream sources (pool servers or your preferred provider).
- Standardize log timestamps to ISO 8601 in scripts and runbooks.
