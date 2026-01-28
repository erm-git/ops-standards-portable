#!/usr/bin/env bash
set -euo pipefail

APPLY=0
FORCE=0
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
DEST="${CODEX_HOME}/skills"

usage() {
  cat <<'USAGE'
Install portable Codex skills into $CODEX_HOME/skills.

Usage:
  scripts/install-codex-skill.sh --dry-run
  scripts/install-codex-skill.sh --apply

Options:
  --apply        Write changes (default is dry-run)
  --dry-run      Show what would change
  --force        Overwrite existing skill directory
  --dest <path>  Override destination (default: $CODEX_HOME/skills)
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --dry-run) APPLY=0; shift ;;
    --force) FORCE=1; shift ;;
    --dest) DEST="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
bundle_templates="${ROOT}/templates"
bundle_scripts="${ROOT}/scripts"

install_skill() {
  local name="$1"
  local src="${ROOT}/codex/skills/${name}"
  local dst="${DEST}/${name}"
  local vendor="${2:-0}"

  if [[ ! -d "${src}" ]]; then
    echo "ERROR: skill source not found: ${src}" >&2
    exit 2
  fi

  if [[ "${APPLY}" != "1" ]]; then
    echo "Dry run: would install skill to: ${dst}" >&2
    echo "  - skill source: ${src}" >&2
    if [[ "${vendor}" == "1" ]]; then
      echo "  - vendor bootstrap: ${bundle_scripts}/bootstrap.sh" >&2
      echo "  - vendor templates: ${bundle_templates}/" >&2
    fi
    if [[ -d "${dst}" ]]; then
      rsync "${args[@]}" "${src%/}/" "${dst%/}/"
    else
      echo "  (destination does not exist; re-run with --apply to write files)" >&2
    fi
    return 0
  fi

  mkdir -p "${DEST}"

  if [[ -e "${dst}" && "${FORCE}" != "1" ]]; then
    echo "ERROR: destination exists (use --force): ${dst}" >&2
    exit 2
  fi

  if [[ "${FORCE}" == "1" ]]; then
    rm -rf "${dst}"
  fi

  mkdir -p "${dst}"
  rsync "${args[@]}" "${src%/}/" "${dst%/}/"

  if [[ "${vendor}" == "1" ]]; then
    mkdir -p "${dst}/vendor/scripts" "${dst}/vendor/templates"
    rsync "${args[@]}" "${bundle_scripts%/}/bootstrap.sh" "${dst%/}/vendor/scripts/bootstrap.sh"
    rsync "${args[@]}" "${bundle_templates%/}/" "${dst%/}/vendor/templates/"
  fi
}

if [[ ! -d "${bundle_templates}" ]]; then
  echo "ERROR: portable templates not found: ${bundle_templates}" >&2
  exit 2
fi
if [[ ! -d "${bundle_scripts}" ]]; then
  echo "ERROR: portable scripts dir not found: ${bundle_scripts}" >&2
  exit 2
fi

args=(-a --delete)
if [[ "${APPLY}" != "1" ]]; then
  args+=(--dry-run)
fi

install_skill "portable-ops-sync" 0
install_skill "codex-new-project" 1
install_skill "codex-new-session" 0
