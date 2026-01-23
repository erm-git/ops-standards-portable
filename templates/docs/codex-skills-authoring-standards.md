---
title: "Codex Skills Authoring Standards"
status: "standard"
---

## Purpose

Keep skills predictable, discoverable, and low-context.

## Structure

- Each skill is a folder containing a required `SKILL.md`.
- Optional subfolders:
  - `scripts/` (deterministic helpers)
  - `references/` (docs loaded only when needed)
  - `assets/` (templates/files not meant to be loaded into context)

## SKILL.md requirements

- Must include YAML front matter:
  - `name:`
  - `description:`
- Use AgentSkills constraints:
  - `name`: 1–64 chars; lowercase letters/numbers/hyphens; no leading/trailing `-`; no `--`; must match directory name.
  - `description`: 1–1024 chars; must describe what the skill does and when to use it (include keywords).
- Optional fields (when needed): `license`, `compatibility`, `metadata`, `allowed-tools` (experimental).
- Keep the body short and procedural.
- Point to `references/` for longer material.

Reference: `https://developers.openai.com/codex/skills`
Reference (skills format): `https://agentskills.io/specification`
