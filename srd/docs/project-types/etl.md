---
title: "ETL Project Standard (Portable SRD)"
status: "standard"
---

## Scope

Applies to ETL-style repos that ingest raw inputs, transform/clean, and promote outputs to `docs/`.

## Required layout

- `etl/input/` — raw inputs (original files, exports, source drops)
- `etl/output/` — **first-stage extraction artifacts** (monolithic outputs)
- `etl/tmp/` — working area (cleaning, linting, chunking, indexing)
- `docs/` — final, canonical outputs

## Required workflow

1) **Ingest** into `etl/input/` (raw, unchanged).
2) **Extract** into `etl/output/` as a **single monolithic artifact** per source:
   - primary output is a monolithic `.md` (with images extracted if available).
   - this file is the authoritative “first-stage” copy.
3) **Process** in `etl/tmp/`:
   - lint/format the monolithic text.
   - split/label/section as needed.
   - generate indexes or metadata.
4) **Promote** into `docs/`:
   - only finalized, cleaned, and labeled outputs land here.

## Notes

- `etl/output/` is **not** a final destination. It is the durable first-stage snapshot.
- `docs/` is the canonical output for readers/agents.

## Optional Make targets

- `make etl-extract` → input → output (monolithic)
- `make etl-process` → output → tmp
- `make etl-promote` → tmp → docs
- `make etl-clean` → clean tmp artifacts
