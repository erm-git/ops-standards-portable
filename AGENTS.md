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

## Required procedure (new or existing host)

If `${LIVE_ROOT}` does not exist, execute the steps in `docs/linux-seed.md` first.
Then return here and continue.

1) Clone portable baseline (tracking clone):

```bash
sudo mkdir -p "${TRACKING_ROOT}"
sudo chown "$USER":"$USER" "${TRACKING_ROOT}"
git clone git@github.com:erm-git/ops-standards-portable.git "${TRACKING_ROOT}"
```

2) Ensure live copy exists:

```bash
sudo mkdir -p "${LIVE_ROOT}"
sudo chown "$USER":"$USER" "${LIVE_ROOT}"
```

3) Template copy (required):

```bash
mkdir -p "${LIVE_ROOT}/templates"
rsync -a "${TRACKING_ROOT}/templates/" "${LIVE_ROOT}/templates/"
```

4) Run SRD block sync (portable → live):

```bash
"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}"
"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --apply
```

Block sync only updates files that already exist; it will skip empty live roots.

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
