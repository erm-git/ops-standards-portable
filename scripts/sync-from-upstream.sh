#!/usr/bin/env bash
set -euo pipefail

APPLY=0
REPORT=""
LIVE_ROOT=""
TRACKING_ROOT=""

usage() {
  cat <<'USAGE'
Sync portable SRD blocks from tracking clone into a live copy (no rsync overwrite).

Usage:
  scripts/sync-from-upstream.sh --live /opt/ops-standards
  scripts/sync-from-upstream.sh --live /opt/ops-standards --apply

Options:
  --live <path>     Live copy root (required)
  --tracking <path> Tracking clone root (defaults to this repo root)
  --apply           Write changes (default is dry-run)
  --report <path>   Write output to a file (in addition to stdout)
  -h, --help        Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --live) LIVE_ROOT="${2:-}"; shift 2 ;;
    --tracking) TRACKING_ROOT="${2:-}"; shift 2 ;;
    --report) REPORT="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TRACKING_ROOT="${TRACKING_ROOT:-$ROOT}"

if [[ -z "${LIVE_ROOT}" ]]; then
  echo "ERROR: --live <path> is required (example: --live /opt/ops-standards)" >&2
  exit 2
fi

if [[ ! -d "${TRACKING_ROOT}/templates" || ! -f "${TRACKING_ROOT}/VERSION" ]]; then
  echo "ERROR: tracking root missing required paths: ${TRACKING_ROOT}" >&2
  exit 2
fi

if [[ ! -d "${LIVE_ROOT}" ]]; then
  echo "ERROR: live root not found: ${LIVE_ROOT}" >&2
  exit 2
fi

run_cmd() {
  if [[ -n "${REPORT}" ]]; then
    "$@" | tee -a "${REPORT}"
  else
    "$@"
  fi
}

if [[ -n "${REPORT}" ]]; then
  : > "${REPORT}"
fi

tracking_version="$(cat "${TRACKING_ROOT}/VERSION")"
live_version=""
if [[ -f "${LIVE_ROOT}/VERSION" ]]; then
  live_version="$(cat "${LIVE_ROOT}/VERSION")"
fi

core_targets=(
  "${LIVE_ROOT}/AGENTS.md"
  "${LIVE_ROOT}/README.md"
  "${LIVE_ROOT}/CHANGELOG.md"
  "${LIVE_ROOT}/docs/index.md"
  "${LIVE_ROOT}/docs/current-state.md"
  "${LIVE_ROOT}/docs/roadmap.md"
)

existing_core=0
for path in "${core_targets[@]}"; do
  if [[ -f "${path}" ]]; then
    existing_core=$((existing_core+1))
  fi
done

if [[ "${existing_core}" -eq 0 ]]; then
  echo "ERROR: live root appears empty (no core docs present)."
  echo "Seed templates first, then re-run block sync."
  echo "Example:"
  echo "  rsync -a \"${TRACKING_ROOT}/templates/repo-root/\" \"${LIVE_ROOT}/\""
  echo "  mkdir -p \"${LIVE_ROOT}/docs\""
  echo "  rsync -a \"${TRACKING_ROOT}/templates/docs/\" \"${LIVE_ROOT}/docs/\""
  exit 3
fi

echo "Tracking root: ${TRACKING_ROOT}"
echo "Live root: ${LIVE_ROOT}"
echo "Tracking VERSION: ${tracking_version}"
if [[ -n "${live_version}" ]]; then
  echo "Live VERSION: ${live_version}"
else
  echo "Live VERSION: (missing)"
fi
echo "Mode: $([[ "${APPLY}" == "1" ]] && echo apply || echo dry-run)"

declare -a MAPS=(
  "AGENTS.md::templates/repo-root/AGENTS.md"
  "README.md::templates/repo-root/README.md"
  "CHANGELOG.md::templates/repo-root/CHANGELOG.md"
  "docs/index.md::templates/docs/index.md"
  "docs/current-state.md::templates/docs/current-state.md"
  "docs/roadmap.md::templates/docs/roadmap.md"
  "docs/active-work.md::templates/docs/active-work.md"
  "templates/repo-root/AGENTS.md::templates/repo-root/AGENTS.md"
  "templates/repo-root/README.md::templates/repo-root/README.md"
  "templates/repo-root/CHANGELOG.md::templates/repo-root/CHANGELOG.md"
  "templates/docs/index.md::templates/docs/index.md"
  "templates/docs/current-state.md::templates/docs/current-state.md"
  "templates/docs/roadmap.md::templates/docs/roadmap.md"
  "templates/docs/active-work.md::templates/docs/active-work.md"
)

python_block_sync() {
  local src="$1"
  local dst="$2"
  local apply="$3"
  PORTABLE_VERSION="${tracking_version}" python3 - "$src" "$dst" "$apply" <<'PY'
import io
import sys
from pathlib import Path
import os

SRC = Path(sys.argv[1])
DST = Path(sys.argv[2])
APPLY = sys.argv[3] == "1"
VERSION = os.environ.get("PORTABLE_VERSION", "")

BEGIN = "<!-- SRD:BEGIN -->"
END = "<!-- SRD:END -->"

def read_text(p: Path):
    return p.read_text(encoding="utf-8")

def block_span(text: str):
    b = text.find(BEGIN)
    e = text.find(END)
    if b == -1 or e == -1 or e < b:
        return None
    e = e + len(END)
    return (b, e)

if not SRC.exists():
    print(f"SKIP_SOURCE|missing source: {SRC}")
    sys.exit(0)
if not DST.exists():
    print(f"SKIP_TARGET|missing target: {DST}")
    sys.exit(0)

src_text = read_text(SRC)
dst_text = read_text(DST)

src_span = block_span(src_text)
dst_span = block_span(dst_text)

if not src_span:
    print(f"SKIP_SRC_BLOCK|missing SRD block in source: {SRC}")
    sys.exit(0)
if not dst_span:
    print(f"SKIP_DST_BLOCK|missing SRD block in target: {DST}")
    sys.exit(0)

src_block = src_text[src_span[0]:src_span[1]]
if VERSION:
    src_block = src_block.replace("{{PORTABLE_VERSION}}", VERSION)
dst_block = dst_text[dst_span[0]:dst_span[1]]

if src_block == dst_block:
    print(f"OK|no change: {DST}")
    sys.exit(0)

if APPLY:
    new_text = dst_text[:dst_span[0]] + src_block + dst_text[dst_span[1]:]
    DST.write_text(new_text, encoding="utf-8")
    print(f"UPDATED|SRD block updated: {DST}")
else:
    print(f"WOULD_UPDATE|SRD block would update: {DST}")
PY
}

updated=0
would_update=0
no_change=0
skip_source=0
skip_target=0
skip_src_block=0
skip_dst_block=0

for entry in "${MAPS[@]}"; do
  target_rel="${entry%%::*}"
  source_rel="${entry##*::}"
  src_path="${TRACKING_ROOT}/${source_rel}"
  dst_path="${LIVE_ROOT}/${target_rel}"
  out="$(python_block_sync "${src_path}" "${dst_path}" "${APPLY}")"
  run_cmd echo "${out}"
  case "${out}" in
    UPDATED* ) updated=$((updated+1)) ;;
    WOULD_UPDATE* ) would_update=$((would_update+1)) ;;
    OK* ) no_change=$((no_change+1)) ;;
    SKIP_SOURCE* ) skip_source=$((skip_source+1)) ;;
    SKIP_TARGET* ) skip_target=$((skip_target+1)) ;;
    SKIP_SRC_BLOCK* ) skip_src_block=$((skip_src_block+1)) ;;
    SKIP_DST_BLOCK* ) skip_dst_block=$((skip_dst_block+1)) ;;
  esac

done

if [[ "${APPLY}" == "1" ]]; then
  run_cmd cp "${TRACKING_ROOT}/VERSION" "${LIVE_ROOT}/VERSION"
  if [[ "${tracking_version}" == "${live_version}" ]]; then
    run_cmd echo "VERSION: no change (${tracking_version})"
  else
    run_cmd echo "VERSION: updated ${live_version:-missing} -> ${tracking_version}"
  fi
else
  if [[ "${tracking_version}" == "${live_version}" ]]; then
    run_cmd echo "VERSION: no change (${tracking_version})"
  else
    run_cmd echo "VERSION: would update ${live_version:-missing} -> ${tracking_version}"
  fi
fi

echo \"Summary: updated=${updated} would_update=${would_update} no_change=${no_change} skip_source=${skip_source} skip_target=${skip_target} skip_src_block=${skip_src_block} skip_dst_block=${skip_dst_block}\"
