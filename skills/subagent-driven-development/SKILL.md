---
name: subagent-driven-development
description: Use when executing a written plan and a bounded delivery slice benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

You are here because delegation was already chosen. What follows is what the
controller cannot recover from the code once workers are running.

The controller owns scope, integration, user decisions, and final acceptance;
each worker owns a precise file or responsibility boundary. Delegate coherent
outcomes, not mechanical steps.

## Concurrency

Parallel workers are appropriate only when their file ownership is disjoint and
neither depends on the other's uncommitted result; otherwise dispatch
sequentially. Use separate worktrees only when the user or project chose them.

In one shared checkout, parallel workers share more than files: a build, a test
run, a dev server, or a port observes every worker's half-finished state, so its
result proves nothing. Parallel workers there edit and report the files they
touched; they do not run shared builds or suites and do not commit. The
controller runs the decisive verification once after integration and commits each
slice on its own, so a slice stays the review and rollback boundary.

Tell each worker it is not alone in the codebase: preserve unknown changes, never
revert another worker's edits, adapt to compatible ones already present.

## Model routing

Choose a worker model only when the harness exposes that control: a fast,
lower-cost model for bounded mechanical edits or read-only exploration, the
current model for normal implementation, the most capable model for architecture,
cross-contract integration, or high-risk final review. Context completeness
outranks cost — a worker on a different model usually starts cold, so its brief
must carry every fact and decision it needs.

## Integration

Inspect the actual diff and rerun decisive evidence — a worker's summary is a
claim, not proof. A worker stops for a decision that changes accepted behavior,
business or data semantics, permissions, a public contract, migration shape, or
an irreversible effect; a disproved locating fact is not such a decision, so it
proceeds from current code and reports it.

After all slices, verify every acceptance condition against the assembled code
and, when relevant, the real consumer or runtime path. Do not create briefs or
review files by default.
