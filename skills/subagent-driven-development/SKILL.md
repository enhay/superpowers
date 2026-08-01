---
name: subagent-driven-development
description: Use when executing a written implementation plan and one or more bounded delivery slices benefit from fresh worker context or delegation, or when the user explicitly requests subagent execution. Do not invoke proactively for trivial work or when dispatch and review overhead exceed the benefit; never delegate work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Delegate coherent implementation outcomes while keeping integration judgment with
the controller. Treat delegation as an ownership tool, not a stage machine.

A plan task is only a candidate boundary. After reading the current code, combine
adjacent tasks, split an unexpectedly large task, keep tightly coupled work local,
or delegate only a bounded part. Never force one plan task to equal one worker,
commit, report, or review.

## Sources of truth

Keep intent and implementation facts separate:

- The plan defines the intended outcome, acceptance, binding decisions, and
  durable public or cross-slice contracts.
- Code, schema, and configuration define the current implemented state.
- Runtime observations and data define what the system actually does.
- `git log` and the current diff define committed progress.
- An optional ledger carries only uncommitted, execution-window facts that are not
  recoverable from the diff.

When plan and code differ, do not make them match mechanically. Reversible local
differences are implementation freedom. A difference in accepted behavior,
business semantics, data, permissions, public contract, or irreversible effects
requires controller adjudication: decide whether the code is wrong, a plan premise
was false, or the intended decision changed.

## When to delegate

Delegate when a slice has a clear responsibility boundary and fresh context adds
real value, or when the user explicitly requests subagents. An explicit request
overrides the overhead preference, not workspace safety or ownership isolation.

Keep work with the main agent when the change is trivial, tightly coupled, or
would require the controller to relay most discoveries between workers. Do not
start a separate explorer unless literal search and local call-chain inspection
failed and a bounded read-only investigation would materially help.

Run implementation workers sequentially in one shared workspace. Parallel workers
require separate, explicitly authorized worktrees and disjoint ownership.

## Workspace and authority

Inspect every affected repository before dispatch. Unknown uncommitted work
belongs to the user. A clearly disjoint slice may proceed, but never dispatch a
worker into overlapping files or commit a mixed diff. If ownership cannot be
isolated, ask whether to use a standard git worktree.

Workers commit verified slices by default. Local commits are recoverable and give
review, rollback, and continuation a real boundary. Never push, deploy, migrate,
write to production, create or switch branches, or create a worktree unless the
user or project explicitly authorizes it. A plan does not grant that authority.

## Execution loop

1. Read the plan, repository instructions, workspace status, relevant code, and
   recent git history. Identify the next coherent outcome and its honest ownership
   boundary.
2. Dispatch one worker with the plan path, outcome, ownership, relevant acceptance
   and binding-decision IDs, current integration facts, verification target, work
   directory, and explicit action permissions. Use
   [implementer-prompt.md](implementer-prompt.md) as a checklist or fallback
   template, not as mandatory ceremony.
3. Let the worker inspect the code, choose reversible implementation, implement,
   verify, self-review, and commit. Resolve only genuine `NEEDS_CONTEXT` or
   `BLOCKED` results; do not take ordinary local choices back from the worker.
4. Inspect the actual code, diff, commit, and verification. Judge the observable
   outcome, scope, and binding decisions—not whether the worker followed an
   imagined implementation sequence.
5. Add independent review when the user requests it, the worker reports
   correctness concerns, or the slice changes public/cross-repository contracts,
   data semantics, permissions, irreversible state, or several interacting
   components. Controller inspection plus direct verification is enough for a
   low-risk local slice. Prefer the harness's native review; otherwise use
   [task-reviewer-prompt.md](task-reviewer-prompt.md).
6. Resolve blocking findings, re-check the changed scope, and continue. Apply a
   focused fix directly or return a broader coherent fix to one worker.

Do not pause between slices unless progress is genuinely blocked, a user decision
is required, or execution is complete.

Before claiming completion, verify every acceptance condition against the
assembled code and, where relevant, the real consumer or runtime path. Task
reports and task reviews are not evidence that the whole result works. Add a
whole-change review when multiple delegated slices interact, the change crosses
repositories or public boundaries, or the user requests it. Use
[final-review-prompt.md](final-review-prompt.md) only as a fallback when the
harness has no suitable review capability.

## Dispatch context

Pass the smallest context that preserves intent and ownership:

- Always pass the plan path, outcome, ownership boundary, current integration
  facts, verification target, work directory, and explicit permissions.
- Pass a generated task brief only when the selected slice cannot be identified
  clearly from the plan or must survive a long handoff. `scripts/task-brief` is an
  optional formatter, not a required stage.
- Let the worker return a concise status, commit, verification result, and
  concerns. Require a report file only when its detail must be handed to another
  worker or would otherwise flood the controller context.
- Give a reviewer the plan, honest commit range or current diff, and the specific
  outcome under review. A review package is optional when the native review tool
  already scopes the change; otherwise use `scripts/review-package`.
- Persist a review file only when findings must be handed to a fix worker or
  re-reviewed. Keep later rounds distinct rather than overwriting prior findings.

Do not copy the plan, earlier task summaries, or routine verification history into
every dispatch. Workers can read files and git history directly.

## Progress and recovery

Use git as the primary progress record:

- Make each committed slice coherent and name its delivered outcome in the commit
  subject.
- Resume by reading `git log`, the current diff, and the code—not a duplicate task
  checklist.
- Treat a commit as complete only after controller inspection and required
  verification; fix it with a later commit rather than rewriting unrelated user
  history.
- Do not copy commit completion, verification summaries, or review levels into a
  ledger.

Use `scripts/sdd-workspace --ledger PLAN_FILE` only when a slice must remain
uncommitted and execution will span compaction or another controller turn. Record
only facts the next slice needs and cannot recover from the current diff: for
example, a temporary cross-repository interface name or an unresolved dependency.
Do not mark committed slices complete there; `git log` already does that. Keep the
ledger under the git directory and never commit it.

If an uncommitted change cannot be isolated from earlier or unknown work, review
the combined change honestly. Never claim a task-scoped diff that does not exist.

## Plan updates

Follow the update gate in `writing-plans`. Update the plan only when goal,
acceptance, a binding decision, durable contract, real dependency, or a
load-bearing premise changes. Do not write progress, review adjudication,
implementation discoveries, actual file paths, or reversible code differences
back into it.

Evidence-only work updates the plan only when its result changes one of those
durable facts. Otherwise the evidence remains in its natural artifact: code,
query output, report, commit, or runtime record.

## Status handling

- **DONE** — inspect the code, commit, and evidence; continue when sufficient.
- **DONE_WITH_CONCERNS** — resolve correctness or scope concerns before review or
  continuation.
- **NEEDS_CONTEXT** — supply missing task-specific context, then continue.
- **BLOCKED** — diagnose the reason: missing evidence, ownership conflict,
  required user decision, unsuitable slice, or plan defect. Do not retry unchanged.

Reversible local choices belong to the worker. Product, contract, data,
permission, migration, and irreversible choices belong to the controller or user.

## Review discipline

Review the result against accepted behavior and binding decisions. Treat the code
as the implementation evidence and the plan as the intended target. A path hint,
internal name, task split, or suggested mechanism is not a requirement unless the
plan records why it is binding.

Require findings to name a reachable trigger or violated acceptance condition.
Do not add or remove a lock, retry, fallback, checkpoint, idempotency guard,
permission check, or financial safeguard on speculation. Search literal uses,
configuration and string registration, router/boot wiring, jobs and consumers,
and external callers before removing an exported or dynamically wired path.

Keep tests proportional. Use TDD only when the user or project requires it. Add a
lasting test only when a future break could remain silent elsewhere; otherwise
use the smallest direct verification.

## Model selection

Choose a worker model only when the harness exposes meaningful options. Use a
cheap tier for mechanical local work, a capable tier for multi-file integration,
and the strongest available tier for architecture or whole-change review. Do not
invent model IDs or add model choreography when the harness does not support it.

## Never

- Delegate overlapping ownership or let workers revert unrelated changes.
- Use delegation merely because a plan contains several tasks.
- Withhold the plan or current integration facts from a worker.
- Let a worker's self-review replace controller verification.
- Move on with a blocking finding that affects acceptance or a binding decision.
- Treat brief, report, review package, review file, or ledger creation as proof of
  progress.
- Let process artifacts override the current code, diff, git history, or runtime
  evidence.
