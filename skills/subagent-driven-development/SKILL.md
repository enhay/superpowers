---
name: subagent-driven-development
description: Use when executing a written plan and a bounded slice of the work benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

You are here because delegation was already chosen. What follows is what the
controller cannot recover from the code once workers are running.

The controller owns scope, integration, user decisions, and final acceptance;
each worker owns a precise file or responsibility boundary. Delegate coherent
outcomes, not mechanical steps. Unless the harness explicitly forks your context,
a worker starts cold: its brief must carry every fact and decision it needs.

## Slicing

A worker boundary is not the plan's delivery boundary. Delivery slices are cut
for review and rollback; worker slices are cut so each one can be finished from
the code it owns. Cut at business domain and module lines: a worker owning a
whole module answers its own questions from that module, while a slice cutting
across modules re-reads neighbours it does not own and sends the rest back to
you. Merge consecutive plan steps living in one module into one worker; never
split one module across two.

Size the slices into one band. Too small and the worker never repays its fixed
cost — a brief, a cold read of everything it needs, a report, and your
verification, all before it writes a line; too large and it compacts mid-task and
re-reads what it already had. The floor has a concrete test: if writing the brief
would already state the change, make the change yourself.

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

## Reporting

A worker returns the files it touched, the decisions it made, the check it ran
and that check's result where it was allowed to run one, and anything still open.
Not code bodies, not a diff, not raw command output — those hand you back the
reading you delegated to avoid. Give each worker the part of the plan it owns
rather than the whole plan, for the same reason.

## Integration

A worker's summary is a claim, not proof — but the answer is to re-observe the
outcome at its own layer, not to re-read the change. A diff shows what moved, not
whether the accepted result holds. Read the code itself only when the code is the
layer being verified — a permission or security boundary, the shape of a public
contract, the other callers of a shared function — or when nothing runnable
observes the outcome.

A worker stops for a decision that changes accepted behavior, business or data
semantics, permissions, a public contract, migration shape, or an irreversible
effect; a disproved locating fact is not such a decision, so it proceeds from
current code and reports it.

Verification and review are different jobs, and neither pays for the other's
reading. You verify outcomes. A code reviewer is a separate decision, worth its
cold read only for risk no runnable check can see, and spawned once over the
assembled result rather than per slice; when you spawn one it owns that read, so
do not repeat it.

After all slices, verify every acceptance condition against the assembled result
and, when relevant, the real consumer or runtime path. Do not create briefs or
review files by default.
