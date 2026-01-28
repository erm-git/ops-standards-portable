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

echo "Tracking root: ${TRACKING_ROOT}"
echo "Live root: ${LIVE_ROOT}"
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
  python3 - "$src" "$dst" "$apply" <<'PY'
import io
import sys
from pathlib import Path

SRC = Path(sys.argv[1])
DST = Path(sys.argv[2])
APPLY = sys.argv[3] == "1"

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
    print(f"SKIP missing source: {SRC}")
    sys.exit(0)
if not DST.exists():
    print(f"SKIP missing target: {DST}")
    sys.exit(0)

src_text = read_text(SRC)
dst_text = read_text(DST)

src_span = block_span(src_text)
dst_span = block_span(dst_text)

if not src_span:
    print(f"SKIP missing SRD block in source: {SRC}")
    sys.exit(0)
if not dst_span:
    print(f"SKIP missing SRD block in target: {DST}")
    sys.exit(0)

src_block = src_text[src_span[0]:src_span[1]]
dst_block = dst_text[dst_span[0]:dst_span[1]]

if src_block == dst_block:
    print(f"OK no change: {DST}")
    sys.exit(0)

if APPLY:
    new_text = dst_text[:dst_span[0]] + src_block + dst_text[dst_span[1]:]
    DST.write_text(new_text, encoding="utf-8")
    print(f"UPDATED SRD block: {DST}")
else:
    print(f"WOULD UPDATE SRD block: {DST}")
PY
}

for entry in "${MAPS[@]}"; do
  target_rel="${entry%%::*}"
  source_rel="${entry##*::}"
  src_path="${TRACKING_ROOT}/${source_rel}"
  dst_path="${LIVE_ROOT}/${target_rel}"
  run_cmd python_block_sync "${src_path}" "${dst_path}" "${APPLY}"

done

if [[ "${APPLY}" == "1" ]]; then
  run_cmd cp "${TRACKING_ROOT}/VERSION" "${LIVE_ROOT}/VERSION"
else
  if cmp -s "${TRACKING_ROOT}/VERSION" "${LIVE_ROOT}/VERSION"; then
    run_cmd echo "VERSION: no change"
  else
    run_cmd echo "VERSION: would update ${LIVE_ROOT}/VERSION"
  fi
fi
