---
title: "Python Projects"
status: "standard"
---

## Default template (modern)

Baseline structure:

- `pyproject.toml` (PEP 621)
- `src/<pkg>/...` (preferred)
- `tests/...`
- `scripts/` (optional; deterministic helpers)

Tooling (recommended):

- `uv` for virtualenv + dependency management (prefer committing `uv.lock` when used)
- `ruff` for formatting + linting
- `pytest` for tests
- optional: `pyright` (or `mypy`) for type checking

Repo hygiene:

- `.venv/` is local-only (gitignored)
- Keep `scripts/` non-interactive by default; accept flags/env vars instead
