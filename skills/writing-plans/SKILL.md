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
intended result needs attention. A plan is not an as-built inventory, an execution
log, or a source of authority: push, deploy, migration, production-write, branch,
worktree, and local commit decisions follow project and user authority, which the
plan records but does not create.

## Choose the artifact

Choose from the delivery shape:

1. **No artifact** — local change, direct answer, or short diagnosis.
2. **One plan** — one owner delivers one observable outcome through one coordinated
   path, including a cross-repository change released together.
3. **Spec then plans** — multiple independently reviewable plans need shared
   durable architecture, business semantics, or a public contract, or the user
   explicitly asks for a spec.

A single plan is lite. Only plans under a governing spec carry the full structure;
both shapes are in Plan structure below.

Use `docs/plans/YYYY-MM-DD-<slug>.md` for plans and
`docs/specs/YYYY-MM-DD-<slug>.md` for specs unless project instructions say
otherwise. A governing spec lists its plans and each plan links back. Keep a
single-plan decision in the plan itself.

## Before writing

A plan is written once, from an understanding that already exists. An open need, a
load-bearing fact still unverified, or an unsettled decision that binds the
outcome calls for grilling, not a draft — an unsettled decision written into a
plan reads as settled.

What has to be settled first: the core need, the load-bearing facts with their
epistemic status, every decision the Update gate below binds, and the user's
confirmation that all of it is shared.

Scale the architecture to the named producers, consumers, failure modes,
contention points, release constraints, and irreversible operations that the
inspected system actually presents. Resolve reversible implementation choices —
internal names, file placement, library choice, control flow, local decomposition,
commit grouping — from code and repository conventions. They stay out of the
plan, and leaving them open is what keeps implementation free.

Keep the warrant for each boundary, validation, error-handling, or compatibility
item out of the plan text. The plan states what to build; a justification written
into it hardens into a fact that review then has to argue against.

## Plan structure

Delivery is a sequence of coherent outcomes in either shape. Keep producer and
consumer, schema and reader, or state transition and observable UI/API together
when that is the real ownership boundary; split at a real dependency,
ownership boundary, independently reversible risk, or useful verification point.
Record an ordering requirement when it changes the result — that requirement is
itself a binding decision — and let the implementer choose routine local steps
after reading the code. Choose lasting automated tests when a future break could
remain silent from all other project signals; otherwise use direct observation,
build, typecheck, smoke, browser, data, or runtime evidence as appropriate.

### Lite — the default

```markdown
# [Feature] Implementation Plan

> Request: "<the requester's own words>"
> Added later: <who decided what, after the original request>

<One to three paragraphs: who wants to do what, what stops them today, the volume
or operating conditions that set proportionality, and the chosen approach with its
durable boundaries. Write the need so it still holds if the codebase were deleted —
a need that reads "the system lacks X" derives the requirement from the absence
rather than from anyone's goal. Carry re-runnable evidence for load-bearing
current-state claims; mark bounded premises.>

## Acceptance
### <observable outcome>
- **WHEN** <trigger, with the concrete values it takes>
- **THEN** <result someone can observe>

## Out of scope
- <what this plan deliberately does not build, and why it was tempting>

## Delivery
1. <outcome in one sentence> — `<command>`, <its result before the change>
2. ...
```

Write each acceptance entry so a reader could build the check from it without a
follow-up question. "The tests pass" is not an outcome.

Give each delivery step the command that observes it and that command's result
before the change. A check that already passes beforehand verifies nothing, and
recording the prior result is what exposes that.

Out of scope carries what the request or the surrounding system makes tempting and
this plan still refuses. It is the one boundary a single plan needs written down:
not to stop a second reader from reinterpreting it, but to stop execution from
drifting into it.

State a cross-slice contract, a costly-to-rediscover wiring fact, or a real
ordering dependency inside the step that needs it. Do not reserve a field for one.

### Full — only under a governing spec

Add to the lite shape:

- **Spec:** the governing spec path, which links back to this plan.
- **Binding decisions** as an addressable list (`D1`, `D2`), each carrying the
  dated evidence or user choice that established it.
- For a delivery slice that crosses an ownership or contract boundary: its scope,
  the exact contract shape, and the decision IDs it must not reinterpret.

These exist so independently reviewable plans can reference the same decisions
without restating them. A single plan has no second reader to coordinate with,
which is why lite omits them.

## Update gate

Update the plan when execution changes or disproves a durable fact that a later
implementer must continue to use:

1. goal, accepted scope, or acceptance;
2. business semantics, data ownership, permissions, an irreversible effect, a
   public or cross-team contract, or a real ordering constraint;
3. a load-bearing premise whose failure changes one of those decisions;
4. a real durable dependency or required release order;
5. a locating or factual premise that execution disproved, even when goal and
   acceptance are unchanged — strike the original in place and record what the
   code actually showed, because the next implementer will otherwise act on it.

Keep the reversible implementation choices named under Before writing, plus
progress, commits, verification results, and review history, in code, git,
runtime evidence, or execution handoff artifacts. A finding changes the plan when it
changes accepted scope or acceptance; otherwise it remains with its review or
issue. Mark superseded durable decisions in place so their rationale
survives.

## Review

Every plan opens its review with a scope classification, before the ordered checks
below. It is a review output reported to the requester, never a section of the
plan — it exists so a requester who never opens the plan can still judge whether
the plan builds only what was asked.

Restate the core need in the requester's own words, not the plan's. A plan the
model wrote reads as internally consistent even when it drifted from the request;
only the original wording exposes the drift.

Then classify every item the plan proposes to build:

| Class | Warrant it must carry |
|---|---|
| Core | the requesting sentence it delivers |
| Boundary | the reachable state **and** the consequence of leaving it unhandled |
| Compatibility | the existing data or caller that requires it |
| **Unwarranted** | none found — proposed for deletion |

Boundary and compatibility items need both halves of the warrant: a state that is
actually reachable, and a consequence worth fixing. "The network can fail" is
reachable; "a few telemetry events are lost" is usually not a consequence worth
fixing, so the retry queue it appears to justify is unwarranted. An item whose
warrant is missing or half-present goes to Unwarranted.

Scope inflation shows up two ways: a non-empty Unwarranted list, or Boundary plus
Compatibility outweighing Core on a request that was stated simply. Report the
classification even when nothing is unwarranted — the ratio is the signal.

Then review in order: core need and acceptance set priority; later checks are
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

Run this review on every plan. Add an independent pass — a subagent given only the
original request and the plan file, not the conversation that produced it — when
the user asks or a high-risk durable decision warrants fresh eyes: an agent that
watched each item being written finds every item reasonable. The main agent owns
the decision either way.

## After saving

Return the path, the classification, and the execution route, then stop for
confirmation before executing — unless the user authorised execution in the same
request. A bare path and summary give the requester nothing to judge scope
against. Use subagent-driven development when a bounded slice benefits from fresh
context or the user requests delegation. Otherwise inspect, implement, verify
slice outcomes, and verify final acceptance directly.
