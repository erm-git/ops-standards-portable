---
title: "Skills (SKILL.md) Authoring Standard (Portable SRD)"
status: "standard"
---

## Scope

This standard defines how to author Codex/agent skills stored as folders containing `SKILL.md`.

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

Required constraints:

- `name`:
  - 1–64 chars
  - lowercase letters, numbers, and hyphens only
  - must not start or end with a hyphen
  - must not contain consecutive hyphens
  - must match the parent directory name
  - regex: `^[a-z0-9]+(-[a-z0-9]+)*$`
- `description`:
  - 1–1024 chars
  - non-empty
  - describes what it does and when to use it (include keywords)

Optional front matter fields (AgentSkills spec):

- `license` (license name or bundled license file)
- `compatibility` (environment requirements; 1–500 chars)
- `metadata` (string key/value mapping)
- `allowed-tools` (space-delimited allowlist; experimental)

Codex compatibility note:

- Codex currently enforces `name` <= 100 chars and `description` <= 500 chars.
- When targeting Codex, keep both AgentSkills and Codex limits in mind (prefer the stricter limit).

## Writing rules

- Keep `SKILL.md` body short and procedural.
- Include steps, examples, and edge cases when useful.
- Keep `SKILL.md` under ~500 lines; move long content to `references/`.
- Favor progressive disclosure (metadata → instructions → referenced files).
- Use relative file references from the skill root (one level deep; avoid deep chains).
- Keep `scripts/` non-interactive by default (flags/env vars only).
- Scripts should be self-contained or document dependencies, include helpful errors, and handle edge cases.

## Validation

- Use `skills-ref validate <path>` when available.

## References

- Agent Skills specification: `https://agentskills.io/specification`
- go-agentskills validation rules: `https://github.com/sketchdev/go-agentskills`
- skills-ref validator: `https://github.com/numtide/skills-ref`
- OpenAI Codex skills docs: `https://developers.openai.com/codex/skills`
