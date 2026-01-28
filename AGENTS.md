<!-- SRD:BEGIN -->
## System Standards (SRD)

This block is synced from `srd/docs/policies/agents-block.md`. Do not edit here.

- Canonical standards: `srd/docs/`
- SRD block version: `{{PORTABLE_VERSION}}`
- MCP policy: `srd/docs/policies/mcp-standards.md`
- MCP query playbook: `srd/docs/tools/mcp-query-playbook.md`
- Firecrawl is paid — do not use unless explicitly requested.
- If `MCP_REQUIRE_CONFIRM=1`, pass `confirm=true` for write/exec tools.
<!-- SRD:END -->

# Ops-Standards-Portable — Target Host Bootstrap (Machine)

This file is the single entrypoint for agents on a target host.
Follow the steps exactly. Do not improvise.

## Path defaults (override only if required)

```bash
TRACKING_ROOT="/srv/dev/ops-standards-portable"
LIVE_ROOT="/opt/ops-standards"
```

## Required procedure (all hosts)

Run these steps exactly. No other flow is supported.

1) Ensure tracking clone exists and is current:

```bash
if [ ! -d "${TRACKING_ROOT}/.git" ]; then
  sudo mkdir -p "$(dirname "${TRACKING_ROOT}")"
  sudo chown "$USER":"$USER" "$(dirname "${TRACKING_ROOT}")"
  git clone git@github.com:erm-git/ops-standards-portable.git "${TRACKING_ROOT}"
else
  git -C "${TRACKING_ROOT}" pull --ff-only
fi
cat "${TRACKING_ROOT}/VERSION"
```

2) Ensure live copy exists:

```bash
sudo mkdir -p "${LIVE_ROOT}"
sudo chown "$USER":"$USER" "${LIVE_ROOT}"
```

3) Seed/update live copy (required; do not improvise):

```bash
"${TRACKING_ROOT}/scripts/seed-live.sh" --live "${LIVE_ROOT}" --apply
```

Notes:
- `seed-live.sh` performs template seeding, SRD block sync (dry‑run + apply), and VERSION verification.
- `seed-live.sh` pulls the tracking clone by default; use `--no-pull` only if you are offline.
- `seed-live.sh` does **not** run sudo; `${LIVE_ROOT}` must already exist and be writable.
- Do not run `sync-from-upstream.sh` separately; it is already called by `seed-live.sh`.

## Codex session workflow (target host)

1) Open VS Code workspace containing:
   - `${LIVE_ROOT}` (live copy)
   - `${TRACKING_ROOT}` (tracking clone)

2) Set CWD to `${LIVE_ROOT}`.

3) Start Codex:

```
ops-standards-0100 $codex-new-session
```

4) Initial instruction to agent:

```
Gain context from ${TRACKING_ROOT} and implement that process into ${LIVE_ROOT} on this system, then pause.
```

## Rule (no destructive rsync into SRD)

Do **not** `rsync --delete` portable `srd/` into local `srd/`.
Portable updates flow through SRD block sync only.
