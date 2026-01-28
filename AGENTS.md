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

## Required procedure (new or existing host)

1) Clone portable baseline (tracking clone):

```bash
sudo mkdir -p /srv/dev/ops-standards-portable
sudo chown "$USER":"$USER" /srv/dev/ops-standards-portable
git clone git@github.com:erm-git/ops-standards-portable.git /srv/dev/ops-standards-portable
```

2) Ensure live copy exists:

```bash
sudo mkdir -p /opt/ops-standards
sudo chown "$USER":"$USER" /opt/ops-standards
```

3) Bootstrap live copy (required):

```bash
/srv/dev/ops-standards-portable/scripts/bootstrap.sh \
  --target /opt/ops-standards \
  --title "Ops Standards (Local)" \
  --one-line "Local standards and references for this host" \
  --purpose "Local standards repo seeded from portable baseline, with host-specific additions."
```

4) Optional template copy (recommended):

```bash
mkdir -p /opt/ops-standards/templates
rsync -a /srv/dev/ops-standards-portable/templates/ /opt/ops-standards/templates/
```

5) Run SRD block sync (portable → live):

```bash
/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards
/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards --apply
```

## Codex session workflow (target host)

1) Open VS Code workspace containing:
   - `/opt/ops-standards` (live copy)
   - `/srv/dev/ops-standards-portable` (tracking clone)

2) Set CWD to `/opt/ops-standards`.

3) Start Codex:

```
ops-standards-0100 $codex-session-bootstrap
```

4) Initial instruction to agent:

```
Gain context from /srv/dev/ops-standards-portable and implement that process into /opt/ops-standards on this system, then pause.
```

## Rule (no destructive rsync into SRD)

Do **not** `rsync --delete` portable `srd/` into local `srd/`.
Portable updates flow through SRD block sync only.
