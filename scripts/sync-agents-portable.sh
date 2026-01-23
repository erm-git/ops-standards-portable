#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BLOCK_FILE="${ROOT}/srd/agents-block.md"

usage() {
  cat <<'EOF'
Usage: sync-agents-portable.sh <AGENTS.md> [<AGENTS.md> ...]

Replaces the portable block between:
  <!-- PORTABLE:BEGIN --> ... <!-- PORTABLE:END -->

If markers are missing, the block is prepended.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

if [[ ! -f "${BLOCK_FILE}" ]]; then
  echo "Missing portable block: ${BLOCK_FILE}" >&2
  exit 1
fi

BLOCK_CONTENT="$(sed -n '/<!-- PORTABLE:BEGIN -->/,/<!-- PORTABLE:END -->/p' "${BLOCK_FILE}")"
if [[ -z "${BLOCK_CONTENT}" ]]; then
  echo "Portable block markers not found in ${BLOCK_FILE}" >&2
  exit 1
fi

for target in "$@"; do
  if [[ ! -f "${target}" ]]; then
    echo "Skip missing file: ${target}" >&2
    continue
  fi

  cleaned="$(mktemp)"
  awk '
    BEGIN { skip=0 }
    /<!-- SRD:BEGIN -->/ { skip=1; next }
    /<!-- SRD:END -->/ { skip=0; next }
    /<!-- PORTABLE:BEGIN -->/ { skip=1; next }
    /<!-- PORTABLE:END -->/ { skip=0; next }
    { if (!skip) print }
  ' "${target}" > "${cleaned}"

  tmp="$(mktemp)"
  {
    echo "${BLOCK_CONTENT}"
    echo
    cat "${cleaned}"
  } > "${tmp}"
  mv "${tmp}" "${target}"
  rm -f "${cleaned}"
done
