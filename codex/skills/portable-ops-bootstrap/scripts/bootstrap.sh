#!/usr/bin/env bash
set -euo pipefail

SKILL_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# Preferred: when installed via scripts/install-codex-skill.sh, the
# skill carries a vendored copy of the portable bundle under vendor/.
bootstrap="${SKILL_ROOT}/vendor/scripts/bootstrap.sh"

# Fallback: when running from an ops-standards checkout, resolve the
# bundle root and call its bootstrap script.
if [[ ! -x "${bootstrap}" ]]; then
  bundle_root="$(cd -- "${SKILL_ROOT}/../../../.." && pwd)"
  bootstrap="${bundle_root}/scripts/bootstrap.sh"
fi

if [[ ! -x "${bootstrap}" ]]; then
  echo "ERROR: bootstrap script not found/executable: ${bootstrap}" >&2
  exit 1
fi

target="${1:-$(pwd)}"

if [[ ! -d "${target}" ]]; then
  mkdir -p "${target}"
fi

echo "Target: ${target}"
echo

read -r -p "Project title: " title
read -r -p "One-line summary: " one_line
echo "Purpose (finish with Ctrl-D):"
purpose="$(cat)"

if [[ -z "${title}" || -z "${one_line}" || -z "${purpose}" ]]; then
  echo "ERROR: title, one-line, and purpose are required." >&2
  exit 2
fi

"${bootstrap}" --target "${target}" --title "${title}" --one-line "${one_line}" --purpose "${purpose}"

echo
echo "Next: review ${target}/README.md and ${target}/docs/index.md"
