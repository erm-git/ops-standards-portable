#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BLOCK_FILE="${ROOT}/srd/docs/policies/agents-block.md"

usage() {
  cat <<'EOF'
Usage: sync-agents-portable.sh <AGENTS.md> [<AGENTS.md> ...]

Replaces the SRD block between:
  <!-- SRD:BEGIN --> ... <!-- SRD:END -->

If markers are missing, the block is prepended.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

if [[ ! -f "${BLOCK_FILE}" ]]; then
  echo "Missing SRD block: ${BLOCK_FILE}" >&2
  exit 1
fi

BLOCK_CONTENT="$(sed -n '/<!-- SRD:BEGIN -->/,/<!-- SRD:END -->/p' "${BLOCK_FILE}")"
if [[ -z "${BLOCK_CONTENT}" ]]; then
  echo "SRD block markers not found in ${BLOCK_FILE}" >&2
  exit 1
fi

for target in "$@"; do
  if [[ ! -f "${target}" ]]; then
    echo "Skip missing file: ${target}" >&2
    continue
  fi

  if rg -q "<!-- SRD:BEGIN -->" "${target}" && rg -q "<!-- SRD:END -->" "${target}"; then
    tmp="$(mktemp)"
    awk -v block="${BLOCK_CONTENT}" '
      BEGIN { in_block=0 }
      /<!-- SRD:BEGIN -->/ { print block; in_block=1; next }
      /<!-- SRD:END -->/ { in_block=0; next }
      { if (!in_block) print }
    ' "${target}" > "${tmp}"
    mv "${tmp}" "${target}"
  else
    tmp="$(mktemp)"
    {
      echo "${BLOCK_CONTENT}"
      echo
      cat "${target}"
    } > "${tmp}"
    mv "${tmp}" "${target}"
  fi
done
