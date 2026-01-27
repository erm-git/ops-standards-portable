# Secrets Standards (CGP)

This document standardizes how secrets are stored, encrypted, loaded, and backed up on a host.
It is written for environments where secrets must be available after reboot without an interactive unlock.

## Goals

- Put all secrets in one predictable place: `$HOME/.config/secrets/<service>/...`
- Keep secrets out of git history (no plaintext commits).
- Make secrets available to tools/services after reboot (no interactive unlock required).
- Make it obvious which token is which (human-readable identifiers).

## Safety rules

- Never commit plaintext secrets.
- Never paste secrets into chat logs.
- Keep the `age` private key readable only by the intended user/service.

## Directory layout + permissions

Each service gets a directory:

```text
$HOME/.config/secrets/
  github/
  truenas/
  restic/
  alerts/
  ...
```

Minimum permissions (typical single-user host):

- `$HOME/.config/secrets` = `0700`
- each `$HOME/.config/secrets/<service>` = `0700`
- any plaintext secret file = `0600` (avoid plaintext whenever possible)

## The one allowed secret reader

On a host, only one script should read secret files and export environment variables (for example):

- `$HOME/.config/secrets/load.sh`

Everything else consumes env vars only.

Rationale:

- prevents token sprawl and precedence confusion
- keeps MCP config (`~/.codex/config.toml`, IDE MCP registries) free of secrets

## Token identifiers

Whenever a secret is a token, store a non-secret identifier alongside it:

- `README.md` in the service directory with:
  - token name
  - purpose
  - scope
  - created date / expiry

## Tooling

Recommended:

- `age`
- `sops`
- `restic` (for encrypted offsite backups)

Prefer distro packages (system-wide) when available.

## Backups

Required: back up encrypted secrets (SOPS files) offsite with restic.

- Source: `$HOME/.config/secrets/`
- Offsite target: restic repository on B2 (or another offsite object store)
- Store restic credentials as SOPS files under `$HOME/.config/secrets/restic/`

Even if secrets are encrypted at rest (SOPS), treat the restic repository password as sensitive.

See also:

- `srd/docs/policies/backup-standards.md`
 - `srd/docs/policies/backup-standards.md`
