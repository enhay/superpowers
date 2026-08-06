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

A single plan is lite. Only plans under a governing spec carry the full structure;
both shapes are in Plan structure below.

Use `docs/plans/YYYY-MM-DD-<slug>.md` for plans and
`docs/specs/YYYY-MM-DD-<slug>.md` for specs unless project instructions say
otherwise. A governing spec lists its plans and each plan links back. Keep a
single-plan decision in the plan itself.

## Before writing

Establish the need before inspecting: who wants to do what, and what stops them
today. Take it from the request, or ask. Inspection tells you what constrains the
need and what it costs — it does not tell you what the need is. A need discovered
by reading code is a description of the code.

Before creating or updating the plan, run a pre-write clarification gate in the
conversation. Keep two explicit sets and do not mix them:

- **Facts** are observable current-state claims about the code, data, runtime,
  external protocol, or operating conditions. Verify them from the environment or
  an authoritative source; ask the user only for a fact that they uniquely own.
- **Decisions** choose the intended outcome or bind anything listed under
  Decision boundary below. Trace each one to an existing user statement or put
  it to the user.

Within the facts set, label each item's epistemic status instead of flattening all
current-state language into fact:

- **Verified fact** — directly established by re-runnable evidence or an
  authoritative source.
- **Derived inference** — a conclusion whose evidence and reasoning are explicit;
  never restate it as an observed fact.
- **Bounded premise** — an unverified assumption whose scope and validation path
  are explicit.
- **Unknown** — information not currently established; name the evidence that
  would resolve it when it matters.

Inspect the entrypoints, producers, consumers, data model, tests, and existing
documents that establish the facts. Re-run evidence for load-bearing current
state. A claim about where a symbol, constant, or responsibility lives is
load-bearing: carry the re-runnable check that establishes it, such as
`rg 'BILLING_CYCLE_DAYS' src/`. A coverage or completeness claim must also name
what it is measured against, and that denominator cannot come from the system's
own registry or declaration — "42 of 42 registered" proves the list agrees with
itself, not that the list is complete. Mark an unresolved fact as a bounded
premise when the repository cannot settle it.

Describe the core need: the smallest outcome that delivers business value. Scale
the architecture to the named producers, consumers, failure modes, contention
points, release constraints, and irreversible operations that the inspected system
actually presents. Carry a recommendation when a user choice is required.

Before proposing a boundary, validation, error-handling, or compatibility item,
settle the warrant it would have to carry under Review below. An item you cannot
warrant does not enter the decision set or the plan. Keep the warrant itself out
of the plan text — the plan states what to build, and a justification written into
it hardens into a fact that review then has to argue against.

Resolve reversible implementation choices from code and repository conventions.
Keep them out of the decision interview unless coordination or reversal cost makes
one binding. A repository convention can resolve a reversible implementation
choice, but cannot stand in for a product decision.

Check the two sets separately. Facts are ready when every load-bearing
current-state claim is verified, every inference or premise it depends on remains
visibly labelled, and no unknown makes the decision question misleading. An
unknown blocks the plan only when resolving it could change a binding decision;
otherwise preserve its boundary. Decisions are ready when every binding choice
needed to state the result has been explicitly accepted.

Present the clarification result before editing the plan:

- summarize fact items grouped as verified facts, derived inferences, bounded
  premises, and material unknowns;
- classify each unresolved decision by its Decision boundary category;
- ask the decision question and provide one recommended answer with its material
  consequence.

Resolve dependent decisions in dependency order. Ask one question at a time when
an answer changes which branch should be discussed next; do not batch questions
whose answers depend on each other. Do not ask the user to rediscover facts that
inspection can settle.

Only create or update the plan after the user confirms the fact summary and the
recommended or amended decisions form a shared understanding. Do not write an
unconfirmed decision into a "pending" section and then design the rest of the plan
as though one branch had already been selected.

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
2. any other decision bound under Decision boundary;
3. a load-bearing premise whose failure changes one of those decisions;
4. a real durable dependency or required release order;
5. a locating or factual premise that execution disproved, even when goal and
   acceptance are unchanged — strike the original in place and record what the
   code actually showed, because the next implementer will otherwise act on it.

Keep everything Decision boundary leaves to implementation, plus progress,
commits, verification results, and review history, in code, git, runtime
evidence, or execution handoff artifacts. A finding changes the plan when it
changes accepted scope or acceptance; otherwise it remains with its review or
issue. Mark superseded durable decisions in place so their rationale
survives.

## Review

Open every plan review with a scope classification, before the ordered checks
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

Run the review in a subagent given only the original request and the plan file,
not the conversation that produced it. An agent that watched each item being
written will find every item reasonable.

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

Use an independent plan review when the user asks or a high-risk durable decision
benefits from a fresh pass. The main agent owns the decision.

## After saving

Classify what the plan builds before returning it — Core, Boundary, Compatibility,
Unwarranted, as defined under Review. Run it against your own plan; it is not a
step to leave for a later reviewer, who may never be asked for. Return the path,
that classification, and the execution route, then stop for confirmation before
executing — unless the user authorised execution in the same request. The
classification is what a requester reads instead of the plan; a bare path and
summary give them nothing to judge scope against. Use
subagent-driven development when a bounded slice benefits from fresh context or
the user requests delegation. Otherwise inspect, implement, verify slice outcomes,
and verify final acceptance directly.
