---
name: subagent-driven-development
description: Use when executing a written implementation plan and one or more bounded delivery slices benefit from fresh worker context or delegation, or when the user explicitly requests subagent execution. Do not invoke proactively for trivial work or when dispatch and review overhead exceed the benefit; never delegate work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Use delegation to give a coherent implementation outcome a clear owner and fresh
context. Keep integration judgment with the controller. A plan task is a candidate
boundary: after reading the code, combine adjacent tasks, split an unexpectedly
large task, keep tightly coupled work local, or delegate a bounded part.

## Operating model

The plan defines the intended outcome, acceptance, binding decisions, and durable
public or cross-slice contracts. Code, schema, configuration, runtime evidence,
and data define the current system. The controller's active todo/checklist tracks
the current execution. Commits record delivered outcomes. A ledger carries only
uncommitted facts that the current diff cannot recover.

When plan and code differ, preserve reversible implementation freedom. A difference
in accepted behavior, business semantics, data, permissions, public contracts, or
irreversible effects goes to the controller for a decision about the code, the
plan premise, or the intended result.

## Choose the route

Use the main agent for trivial, tightly coupled, or low-risk work. Delegate when a
slice has a clear ownership boundary and fresh context adds value, or when the
user asks for subagents. The delegated slice should be the smallest coherent
outcome the worker can own.

In one shared workspace, run implementation workers sequentially. Keep each
worker's files and responsibility disjoint from unknown user WIP. Separate
worktrees and parallel execution are choices for a project that explicitly uses
them, not defaults of this skill.

## Authority and workspace

Inspect each affected repository, its status, and local instructions before work.
Preserve unknown user changes and keep every commit attributable to the current
slice. Local commits are the normal recovery and review boundary.

Pushes, deployments, migrations, production writes, branch changes, and worktree
creation require explicit user or project permission. Product, public-contract,
data, permission, migration, and irreversible decisions belong with the controller
or user. Reversible local choices belong with the worker who reads the code.

## Execution

1. Read the plan, repository instructions, workspace status, and relevant code.
   Update the active todo/checklist and choose the next coherent outcome and
   ownership boundary. Read targeted history only for a prior commit, interface
   provenance, baseline, or recovery question; scope it to the affected repository,
   path, or commit range.
2. Give a worker the plan path, outcome, ownership, relevant acceptance and
   binding-decision IDs, current integration facts, verification target, work
   directory, and explicit permissions. Use
   [implementer-prompt.md](implementer-prompt.md) when a fallback prompt is useful.
3. Let the worker inspect, implement, verify, self-review, and commit. Resolve
   genuine context or ownership questions at the controller; leave ordinary local
   implementation choices with the worker.
4. Inspect the actual code, diff, commit, and evidence. Judge the result against
   the accepted outcome and binding decisions.
5. Add an independent review when the user requests it or when the slice changes a
   public/cross-repository contract, data semantics, permissions, irreversible
   state, or several interacting components. Controller inspection plus direct
   verification is sufficient for a low-risk local slice. Use the native review
   capability when available; [task-reviewer-prompt.md](task-reviewer-prompt.md) is
   the fallback.
6. Resolve blocking findings, update the active todo, and continue. Before
   completion, verify every acceptance condition against the assembled code and,
   where relevant, the real consumer or runtime path. Use
   [final-review-prompt.md](final-review-prompt.md) for a whole-change review when
   interaction across slices or repositories makes it useful.

The controller can continue through all coherent slices without conversational
check-ins. Pause for a user decision, an ownership conflict, or a genuine blocker.

## Execution state and handoff

Keep the active todo in the controller's native todo state, or in a short
in-context checklist when no native state exists. It records next, active,
blocked, and complete outcomes for the current run.

Create a Markdown handoff only when the current execution must survive a context
reset, another controller must resume it, or the user asks for a continuation
record. Point it at the plan, todo status, relevant commits, current diff boundary,
unresolved dependency, and next action. Keep it separate from the plan's durable
decisions.

Use `git log` for committed outcomes and targeted history questions, not as the
todo. Typical reads are `git log BASE..HEAD`, `git show COMMIT`, and
`git log -- PATH`. The current diff and code cover uncommitted implementation.

Use `scripts/sdd-workspace --ledger PLAN_FILE` only for uncommitted execution
facts that must survive another controller turn and are not visible in the diff.
The ledger is not a completion list; committed outcomes remain in git and current
todo state.

Briefs, reports, review packages, and review files are optional handoff tools:
create them when their detail needs to cross a worker boundary or the native
review cannot carry the required scope. The plan, code, diff, and todo remain the
primary context.

## Plan and verification

Update the plan when goal, acceptance, a binding decision, a durable contract, a
real dependency, or a load-bearing premise changes. Keep implementation details,
progress, review history, and task bookkeeping in their natural artifacts.

Use the smallest evidence that observes the accepted outcome. Make a lasting test
when a future change could silently break the behavior and no other project signal
would expose it. Use TDD when the user or project requires it.

Require a concrete reachable trigger for locks, retries, fallbacks, checkpoints,
idempotency, permission checks, and financial safeguards. Before removing an
exported or dynamically wired path, inspect literal uses, configuration and
string registration, router/boot wiring, jobs and consumers, and external callers.

## Model selection

Choose a worker model only when the harness exposes meaningful options. Match the
model to the work: cheap for mechanical local changes, capable for multi-file
integration, and strongest for architecture or whole-change review.
