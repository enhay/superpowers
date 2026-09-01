---
name: subagent-driven-development
description: Use when executing a written plan and a bounded delivery slice benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Delegate coherent outcomes, not mechanical steps. The controller owns scope,
integration, user decisions, and final acceptance; each worker owns a precise file
or responsibility boundary. Keep trivial, tightly coupled, or low-risk work with
the controller.

## Parallelism

Parallel workers are appropriate only when their file ownership is disjoint and
neither depends on the other's uncommitted result; otherwise dispatch
sequentially. Use separate worktrees only when the user or project chose them.

In one shared checkout, parallel workers share more than files: a build, a test
run, a dev server, or a port observes every worker's half-finished state, so its
result proves nothing. Parallel workers there edit and report the files they
touched; they do not run shared builds or suites and do not commit. The controller
runs the decisive verification once after integration and commits each slice on
its own, so a slice stays the review and rollback boundary.

## Model routing

Choose a worker model only when the harness exposes that control: a fast,
lower-cost model for bounded mechanical edits or read-only exploration, the
current model for normal implementation, the most capable model for architecture,
cross-contract integration, or high-risk final review. Context completeness
outranks cost — a worker on a different model usually starts cold, so its brief
must carry every fact and decision it needs.

## Dispatch

Inspect the plan, affected repositories, local instructions, workspace status, and
relevant code first. Track outcomes in the harness's native todo state.

Give each worker the outcome and observable acceptance it owns, its exact file or
responsibility boundary and working directory, the binding decisions and
integration facts it needs, the smallest verification that observes the outcome,
and explicit authority for any action beyond local edits and commits. Tell it that
it is not alone in the codebase: preserve unknown changes, never revert another
worker's edits, adapt to compatible ones already present. It should inspect,
implement, verify, self-review, and return its changed files, evidence, commit if
one was safe, and any concern.

A worker stops for a decision that changes accepted behavior, business or data
semantics, permissions, a public contract, migration shape, or an irreversible
effect. A disproved locating fact is not a decision: proceed from current code and
report it so the plan can be corrected.

## Integrate and review

Inspect the actual diff and rerun decisive evidence — a worker's summary is a
claim, not proof. Independent review is proportional, not automatic: add a fresh
reviewer when the user asks or the slice changes a public or cross-repository
contract, data semantics, permissions, irreversible state, or several interacting
components. Give it the original outcome, binding decisions, honest diff scope,
verification evidence, and access to the code it judges — a reviewer that cannot
read the system can only return a completeness review, which is the failure mode
rather than a control on it. Ask it to judge outcome compliance first, then
concrete defects. A blocking finding must name a reachable trigger and a material
consequence. "A caller could", "under load", "for robustness", and "a future
change might" are not triggers, and neither is the absence of a mechanism the work
never claimed. An observation that fails this gate is reported as one line without
severity or recommendation and does not block the work.

Resolve supported findings and re-review only the fix scope. After all slices,
verify every acceptance condition against the assembled code and, when relevant,
the real consumer or runtime path. Do not create briefs or review files by
default; use a handoff artifact only when another session must resume facts that
the plan, code, diff, and commits cannot recover.
