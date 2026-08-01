---
name: writing-plans
description: Use only when a durable implementation plan must be written or updated, or when a formal implementation-readiness review of a plan/spec is itself the requested deliverable. Do not use to decide whether planning is needed, explain planning policy, inspect why plan/spec files exist, or answer a narrow question about an artifact.
---

# Writing Plans

Write a plan as the concise product requirement and technical proposal that gives
people a shared basis for approval and gives implementation a durable direction.
Make it **decision-complete and implementation-open**: settle the observable
outcome, acceptance, business semantics, public contracts, and costly or
irreversible choices; leave reversible local implementation to the engineer who
reads the current code.

Keep the sources of truth distinct:

- The plan defines the intended result and its durable constraints.
- Code, schema, configuration, data, and runtime evidence describe the current
  system.
- Execution state and history describe how the current change reached its state.

When these disagree, decide whether the implementation, a plan premise, or the
intended result needs attention. A plan is not an as-built inventory or an
execution log.

## Choose the artifact

Choose from the delivery shape:

1. **No artifact** — local change, direct answer, or short diagnosis.
2. **One plan** — one owner delivers one observable outcome through one coordinated
   path, including a cross-repository change released together.
3. **Spec then plans** — multiple independently reviewable plans need shared
   durable architecture, business semantics, or a public contract, or the user
   explicitly asks for a spec.

Use `docs/plans/YYYY-MM-DD-<slug>.md` for plans and
`docs/specs/YYYY-MM-DD-<slug>.md` for specs unless project instructions say
otherwise. A governing spec lists its plans and each plan links back. Keep a
single-plan decision in the plan itself.

## Before writing

Inspect the entrypoints, producers, consumers, data model, tests, and existing
documents that establish the result. Re-run evidence for load-bearing current
state. Mark an unresolved fact as a bounded premise when the repository cannot
settle it.

Describe the core need: the smallest outcome that delivers business value. Scale
the architecture to the named producers, consumers, failure modes, contention
points, release constraints, and irreversible operations that the inspected system
actually presents. Carry a recommendation when a user choice is required.

Resolve reversible implementation choices from code and repository conventions.
Ask a consolidated direction-level question when the user must choose before a
contract can be stated. If the user asks to be interrogated, ask one grounded
question at a time and write after the direction is shared.

## Decision boundary

Bind decisions whose reinterpretation changes the delivered product or is costly
to reverse:

- observable goal and acceptance;
- user decisions and business semantics;
- data ownership, migration destination, permissions, and irreversible effects;
- public, external, cross-team, or independently released contracts;
- real ordering constraints and the evidence that proves the outcome.

Leave internal names, file placement, library choice, control flow, local
decomposition, worker choice, review choreography, and commit grouping to the
implementation unless coordination or reversal cost makes one binding.

## Plan structure

```markdown
# [Feature] Implementation Plan

**Spec:** `docs/specs/...` — only when a governing spec links back.
**Background:** current state, problem, and why it matters. Include re-runnable
evidence for load-bearing current-state claims; mark bounded premises.
**Goal:** one observable sentence.
**Core need:** smallest valuable form and the volume or operating conditions that
determine proportionality.
**Acceptance:** concrete observations that prove the goal.
**Architecture:** chosen approach and durable boundaries, briefly.

## Binding decisions
- **D1:** durable decision and, when useful, the dated evidence or user choice
  that established it.

## Delivery slices
### Task N: [coherent outcome]
**Outcome:** observable behavior this slice completes.
**Scope:** responsibility or ownership boundary.
**Depends on:** real predecessor or external prerequisite; omit otherwise.
**Binding decisions:** only IDs this slice must not reinterpret.
**Contract:** exact shape for a public, external, or cross-slice interface.
**Known path:** consequential existing wiring or ownership facts.
**Verification:** smallest direct evidence that proves the outcome.
**Implementation note:** optional non-obvious fact costly to rediscover.
```

Keep a delivery slice as a coherent outcome. Keep producer and consumer, schema
and reader, or state transition and observable UI/API together when that is the
real ownership boundary. Split at a real dependency, ownership boundary,
independently reversible risk, or useful verification point.

Record an ordering requirement when it changes the result; that requirement is a
binding decision. Let the implementer choose routine local steps after reading the
code. Choose lasting automated tests when a future break could remain silent from
all other project signals; otherwise use direct observation, build, typecheck,
smoke, browser, data, or runtime evidence as appropriate.

The plan records intent and authority. Push, deploy, migration, production-write,
branch, worktree, and local commit decisions follow project and user authority;
the plan itself does not create that authority.

## Update gate

Update the plan when execution changes or disproves a durable fact that a later
implementer must continue to use:

1. goal, accepted scope, or acceptance;
2. business semantics, data ownership, permissions, public contract, or an
   irreversible choice;
3. a load-bearing premise whose failure changes one of those decisions;
4. a real durable dependency or required release order.

Keep file paths, internal signatures, task splits, agent assignments, progress,
commits, verification results, review history, and reversible implementation in
code, git, runtime evidence, or execution handoff artifacts. A finding changes the
plan when it changes accepted scope or acceptance; otherwise it remains with its
review or issue. Mark superseded durable decisions in place so their rationale
survives.

## Review

Review in order: core need and acceptance set priority; later checks are
conditional filters, not categories the plan must fill.

1. Does the core need deliver the valuable result at a proportionate cost?
2. Are load-bearing premises verified or clearly bounded?
3. Does every acceptance condition have an observable success and failure result?
4. Are business, data, permission, public-contract, and migration semantics exact?
5. Does each resilience, compatibility, rollout, or concurrency mechanism have a
   concrete trigger and material consequence in the observed system?
6. Are irreversible points, approvals, ownership, and real dependencies clear?
7. Can a reader outside the conversation understand the problem, outcome, and
   chosen approach?
8. Does implementation retain freedom over reversible local choices?

Use an independent plan review when the user asks or a high-risk durable decision
benefits from a fresh pass. The main agent owns the decision.

## After saving

Return the path, a concise outcome summary, and the execution route. Use
subagent-driven development when a bounded slice benefits from fresh context or
the user requests delegation. Otherwise inspect, implement, verify slice outcomes,
and verify final acceptance directly.
