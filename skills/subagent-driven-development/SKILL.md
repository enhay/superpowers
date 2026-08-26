---
name: subagent-driven-development
description: Use when executing a written plan and a bounded delivery slice benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Delegate coherent outcomes, not mechanical steps. The controller owns scope,
integration, user decisions, and final acceptance; each worker owns a precise
file or responsibility boundary.

## Choose the route

Keep trivial, tightly coupled, or low-risk work with the controller. Delegate only
when fresh context or independent execution has a concrete benefit.

Parallel workers are appropriate only when their file ownership is disjoint and
neither depends on the other's uncommitted result. Otherwise dispatch
sequentially. In one shared checkout, parallel workers do not commit
independently; the controller reviews and commits their slices after integration.
Use separate worktrees only when the user or project explicitly chose them.

## Dispatch

Before dispatching, inspect the plan, affected repositories, local instructions,
workspace status, and relevant code. Track outcomes in the harness's native todo
state or a short in-context checklist.

Give each worker:

- the outcome and observable acceptance it owns;
- exact files or responsibility boundary, working directory, and dependencies;
- relevant binding decisions and current integration facts;
- the smallest verification that observes the outcome;
- explicit authority for any action beyond local edits and commits.

Tell the worker it is not alone in the codebase: preserve unknown changes, never
revert another worker's edits, and adapt to compatible changes already present.
The worker should inspect, implement, verify, self-review, and return the changed
files, evidence, commit if one was safe, and any concern.

A worker stops for a decision that changes accepted behavior, business or data
semantics, permissions, a public contract, migration shape, or an irreversible
effect. A disproved locating fact is not a decision: proceed from current code
and tell the controller so the plan can be corrected when needed.

## Integrate and review

Inspect the actual diff and rerun decisive evidence; a worker's summary is a
claim, not proof. Keep changes attributable to their slice and make local commits
the review and rollback boundary.

Independent review is proportional, not automatic. Add a fresh reviewer when the
user asks or the slice changes a public or cross-repository contract, data
semantics, permissions, irreversible state, or several interacting components.
Give the reviewer the original outcome, binding decisions, honest diff scope, and
verification evidence. Ask it to judge outcome compliance first, then concrete
defects. A blocking finding must name both a reachable trigger and a material
consequence; speculative possibilities do not block the work.

Resolve supported findings and re-review only the fix scope. After all slices,
verify every acceptance condition against the assembled code and, when relevant,
the real consumer or runtime path.

Do not create briefs, review packages, or review files by default. Use one short
ledger only when native todo state is unavailable, or a handoff artifact when
another controller or session must resume facts that the plan, code, diff, and
commits cannot recover.
