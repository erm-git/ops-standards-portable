---
title: "Skills (SKILL.md) Authoring Standard"
status: "standard"
---

## Directory layout

Each skill is a directory:

- `SKILL.md` (required)
- `scripts/` (optional; deterministic helpers)
- `references/` (optional; large docs loaded on demand)
- `assets/` (optional; templates/static resources)

## `SKILL.md` requirements (AgentSkills format)

`SKILL.md` must start with YAML front matter, then Markdown instructions.

Required front matter fields:

```yaml
---
name: my-skill
description: What this skill does and when to use it.
---
```

Constraints:

- `name`:
  - 1–64 chars
  - lowercase letters, numbers, hyphens only
  - no leading/trailing hyphen, no `--`
  - must match the parent directory name
- `description`:
  - 1–1024 chars
  - must describe what the skill does and when to use it (include keywords)

## Writing rules

- Keep `SKILL.md` body short and procedural.
- Put long reference material in `references/`.
- Keep `scripts/` non-interactive by default (flags/env vars only).

## References

- Agent Skills specification: `https://agentskills.io/specification`
- OpenAI Codex skills docs: `https://developers.openai.com/codex/skills`
