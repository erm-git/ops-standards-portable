---
title: "Markdown Standards (Portable SRD)"
status: "standard"
---

## Rules (summary)

These rules apply to authored markdown under `docs/` in project repos.

- Use YAML front matter with `title:` for authored docs.
- The first in-body heading should be `##` (H2).
- Prefer H2/H3/H4 only.
- Unordered lists use `-` (not `*`).
- Code fences include a language identifier when possible (`bash`, `python`, etc.).
- Prefer relative links within `docs/`.

## Linting

- `.markdownlint-cli2.jsonc` is the source of truth.
