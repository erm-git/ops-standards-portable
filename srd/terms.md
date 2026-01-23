---
title: "Terms (CGP SRD)"
status: "standard"
---

## Purpose

Short, shared terminology for ops standards. When a term appears in docs, tasks, or agent instructions, use these meanings.

## Control plane vs execution plane

Industry‑standard terms:

- **Control plane** — planning, orchestration, policy, coordination
- **Execution plane** (a.k.a. data plane) — implementation, runtime, state changes

If you need to emphasize “process vs repo,” use:

- **control‑plane process** / **execution‑plane process** (workflow meaning)
- **control‑plane repo** / **execution‑plane repo** (project meaning)

## Workflow primitives

- **Staged handoff** (local alias: gated promotion): control plane stages artifacts and a human promotes them into execution.
- **WIP limit** (local alias: single‑flight invariant): only one execution task should be in progress at a time.
- **Directory‑as‑state** (local alias: folder truth): task status is determined by folder placement, not a field inside the YAML.
- **State snapshot** (local alias: status snapshot): a `*.latest.md` file that summarizes computed truth (git + folder state) at a moment in time.
- **Drift detection** (local alias: drift detector): compares computed truth against evidence snapshots and flags mismatches.
- **Black‑box probe**: an evidence run that writes artifacts under `reports/**` without changing the target repo.
- **Read‑only preflight**: computes “what to do next” from live git + folder truth and outputs a paste‑ready prompt.
- **Git review-ready**: stage-only review bundle; no branch changes, rebases, resets, cleans, commits, or pushes.
- **Git checkpoint**: local commit only; no push.
- **Git publish**: stage + commit + push (to the configured remotes) to keep the working tree clean and make the current state durable.

## BP and CCON

- **BP (Best Practice):** Officially documented and recommended way to do something.
- **CCON (Common Convention):** Widely accepted community workflow when BP is absent.

## FHS

- **FHS (Filesystem Hierarchy Standard):** Use for system-wide file placement conventions (for example, sources in `/usr/local/src`, admin scripts in `/usr/local/sbin`).

## Linux vocabulary (short)

- **Program / application:** the thing you run (binary or script).
- **Package:** how software is distributed (deb, rpm, pip, npm).
- **Binary / executable:** runnable file (ELF or script with shebang).
- **Command:** what you type in the shell.
- **Script:** text file run by a shell or interpreter.
- **Process:** running instance of a program.
- **Service / daemon:** background process managed by systemd.
- **Runtime / state:** changing data (DBs, caches, logs).
- **`/usr/local/bin`:** user‑run commands.
- **`/usr/local/sbin`:** commands run by services/timers (systemd).

## SRD

- **SRD (Standards Reference):** A curated, high-signal set of canonical standards and operational references intended for cross-repo reuse.

## MVP+

**MVP+** (“MVP‑plus”, sometimes written `MVPP` or `mvp+`) is a local extension of standard MVP:
**MVP‑better + future‑proof by default**.

Practical intent:

- Prefer the smallest implementation that is still a stable foundation (no known “throwaway” work).
- Prefer decisions that keep extension paths open (stable IDs, clear contracts, deterministic interfaces).
- Defer optional complexity, but do not paint us into a corner for post-MVP.

## Determinism (two meanings)

- **Seed/world determinism:** the same seed + the same versioned inputs produce the same starting world/stocking.
- **Test/replay determinism:** for debugging/CI, the same start state + the same actions + the same RNG draw order produce the same outcomes.

## WRAP (agent task authoring)

**WRAP** is shorthand for authoring effective work items (issues, YAML tasks, task packets):

- **W — Write effective issues:** write tasks as if for someone brand new; include concrete examples and evidence.
- **R — Refine instructions:** improve repo-level and org-level instructions over time; keep them canonical and actionable.
- **A — Atomic tasks:** break large work into small, independent tasks with explicit tests and acceptance checks.
- **P — Pair with the coding agent:** humans handle “why” and ambiguity; agents handle execution and repetition.
