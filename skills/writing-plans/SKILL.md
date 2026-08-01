---
name: writing-plans
description: Use only when a durable implementation plan must be written or updated, or when a formal implementation-readiness review of a plan/spec is itself the requested deliverable. Do not use to decide whether planning is needed, explain planning policy, inspect why plan/spec files exist, or answer a narrow question about an artifact.
---

# Writing Plans

Write a plan as the baseline product requirement and technical proposal for an
implementation. Make it **decision-complete and implementation-open**: settle the
observable outcome, acceptance, business semantics, public contracts, and costly
or irreversible choices; leave reversible local implementation to the engineer
who reads the current code.

Keep the sources of truth distinct:

- The plan defines the intended result and its durable constraints.
- Code, schema, configuration, data, and runtime evidence describe the system as
  it currently exists.

Do not use the plan as an as-built inventory or execution log. Do not treat the
current code as proof that its behavior is the intended requirement. When the two
disagree, determine whether the implementation is wrong, a load-bearing premise
was false, or the intended decision changed.

Several steps are not a trigger. Keep trivial and small work on
`inspect -> implement -> verify`.

## Choose the artifact

Choose from the delivery shape, not the technical topic:

1. **No artifact** — local change, direct answer, short diagnosis.
2. **One plan** — one owner delivers one observable outcome through one
   coordinated path, even across repositories or services.
3. **Spec then plans** — two or more independently reviewable plans need the same
   durable architecture, business semantics, or public contract, or the user
   explicitly asks for a spec.

File, repository, service, screen, and open-question counts do not select a spec.
If one plan can carry the goal, decisions, acceptance, delivery slices, and
verification, keep one plan.

Save plans to `docs/plans/YYYY-MM-DD-<slug>.md` and specs to
`docs/specs/YYYY-MM-DD-<slug>.md`, unless project instructions say otherwise. A
governing spec lists every plan it governs, and each plan links back to it. Do not
duplicate a plan's task list or acceptance in the spec.

## Before writing

Inspect the real entrypoints, producers, consumers, data model, tests, and existing
documents far enough to establish the load-bearing facts. Re-run cheap checks for
drift-prone claims. Mark an unresolved fact as a bounded premise only when current
evidence cannot settle it.

Identify the core need: the smallest outcome that delivers business value. Do not
quietly add fallback, high availability, compatibility layers, projections,
automatic recovery, generalized retries, distributed locks, staged rollout, or
similar completeness machinery. Add one only when a named producer, consumer,
failure mode, contention point, release constraint, or irreversible operation
requires it. If including or excluding it changes the product or architecture,
present the choice and recommendation to the user.

Ask one consolidated question only when the user must choose before the target
contract can be stated. Resolve reversible choices from repository evidence and
existing conventions. Do not manufacture alternatives to make the plan look
thorough.

If the user asks to be interrogated, ask one direction-level question at a time,
grounded in inspected facts and carrying a recommendation. Do not write the plan
until the user says the direction is shared.

## Decision boundary

Bind only decisions whose reinterpretation would change the delivered product or
be expensive to reverse:

- observable goal and acceptance;
- user decisions and business semantics;
- data ownership, migration destination, permissions, and irreversible effects;
- public, external, cross-team, or independently released contracts;
- real ordering constraints and the evidence that proves the outcome.

Leave these to implementation unless a concrete coordination or reversal-cost
reason makes one binding:

- internal names and signatures;
- exact file placement and library choice;
- control-flow shape and local decomposition;
- task-to-agent mapping, review choreography, and commit grouping.

The test is simple: would a capable implementer have to invent a product,
contract, data, permission, or irreversible decision? If not, state the outcome
and responsibility boundary, then stop.

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
**Contract:** exact shape only for a public, external, or cross-slice interface.
**Known path:** only consequential existing wiring or ownership facts.
**Verification:** smallest direct evidence that proves the outcome.
**Implementation note:** optional non-obvious fact costly to rediscover.
```

Treat a delivery slice as a coherent outcome, not a promise of one dispatch, one
commit, or one review. Keep producer and consumer, schema and reader, or state
transition and observable UI/API together when splitting would create an
interface only for the plan. Split only for a real dependency, ownership boundary,
independently reversible risk, or useful verification point.

Do not prescribe routine steps inside a task. Record an ordering requirement only
when getting it wrong changes the result; then it is a binding decision.

Specify a lasting automated test only when a later change could silently break
the behavior and no existing test, typecheck, build, or normal use would expose
the break. Otherwise make the one-time observation the verification deliverable.

A plan never grants push, deploy, migration, production-write, branch, or worktree
authority. Record such authority only when the user or project explicitly grants
it. Local commit boundaries belong to execution, not the plan.

## Update gate

Update the plan only when execution changes or disproves something a later
implementer must continue to treat as durable:

1. goal, accepted scope, or acceptance;
2. business semantics, data ownership, permissions, public contract, or an
   irreversible choice;
3. a load-bearing premise whose failure changes one of those decisions;
4. a real durable dependency or required release order.

Do not update the plan for discovered file paths, internal signatures, task
splits, agent assignments, progress, commits, verification results, review
verdicts, rejected alternatives, or differences in reversible implementation.
Those facts live in the code, git history, runtime evidence, or the temporary
handoff that needs them.

Correct an incidental current-state statement only when the plan still relies on
it. When a disproved premise carried a binding decision, present the evidence,
consequence, and recommendation instead of silently rewriting the decision. When
a finding deliberately remains unfixed, update the plan only if the user changes
accepted scope or acceptance; otherwise keep the finding in its review or issue.

Mark a superseded durable decision in place rather than deleting its rationale.
Do not preserve conversation rebuttals or discarded mechanisms.

## Review

Review decisions and omissions, not prose style or hypothetical implementation
quality. Check:

1. Does the core need alone deliver value, without unrequested machinery?
2. Are load-bearing premises verified or clearly bounded?
3. Does each acceptance condition have an observable success and failure result?
4. Are business, data, permission, public-contract, and migration semantics exact?
5. Does every lock, retry, fallback, compatibility path, or rollout mechanism name
   a reachable trigger?
6. Are irreversible points and required approvals explicit and localized?
7. Do delivery slices reflect ownership and real dependencies rather than
   artificial review units?
8. Does the plan leave reversible implementation choices open?
9. Can a reader outside the conversation understand the problem, outcome, and
   chosen approach?

Use an independent plan review only when the user asks or a high-risk durable
decision benefits from a fresh pass. The main agent owns adjudication.

## After saving

Return a concise summary, path, and execution route. Use
`subagent-driven-development` only when a bounded slice benefits from fresh worker
context or the user explicitly requests delegation. Otherwise execute directly:
inspect current code, implement, verify slice outcomes, and verify final
acceptance. Do not create SDD artifacts for direct execution.
