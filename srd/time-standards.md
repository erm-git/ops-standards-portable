# Time Standards (CGP)

This document defines canonical timestamp rules used across ops workflows and tooling.

## Canonical Run ID (required)

All run identifiers must use UTC in basic ISO-8601 form:

- Format: `YYYYMMDDTHHMMSSZ`
- Example: `20260108T185841Z`
- Regex: `^[0-9]{8}T[0-9]{6}Z$`

Use this format for:

- run directories under `logs/**` and `reports/**`
- handshake/status artifacts
- any durable “evidence” runs

## Clock discipline (required)

The host clock must be synchronized via NTP (systemd-timesyncd, chrony, etc.).

Pick one authoritative time source per environment:

- your router/firewall (if it provides NTP), or
- an internal NTP server, or
- the public NTP pool

If the host clock is not synchronized, timestamps are not authoritative.

## Human-readable time (reference only)

Local time formats are for human reference only and must never be used in logs, report filenames, or run IDs.

- Local 24-hour: `date +"%Y-%m-%d %H:%M %Z (%z)"`
- Local 12-hour: `date +"%Y-%m-%d %I:%M%p %Z (%z)"`

## Notes

- Do not rely on UI chat timestamps for logging or traceability.
- If a tool needs a time value, it should generate a UTC run ID.
