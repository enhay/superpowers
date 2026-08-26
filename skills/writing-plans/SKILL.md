---
name: writing-plans
description: Use only to create or update a durable implementation plan or spec, or to perform a formal implementation-readiness review of one. Do not use for planning-policy questions, narrow artifact inspection, direct answers, or routine local changes.
---

# Writing Plans

Write a durable agreement about the intended result, not a transcript or an
implementation recipe. The artifact must be **decision-complete and
implementation-open**: exact about observable outcomes and costly boundaries,
but silent about reversible local choices the implementer can recover from code.

## Preconditions

Write only after the need, load-bearing facts, binding decisions, and acceptance
are settled and confirmed by the user. If any of those remain open, use
`grilling`; do not encode an unresolved branch as a draft or `pending` item.

Keep sources of truth separate:

- the plan defines the intended result and durable constraints;
- code, schema, configuration, data, and runtime evidence define current state;
- todo state, commits, reviews, and handoffs define execution progress.

A plan records authority; it does not grant permission to push, deploy, migrate,
write production data, or perform another external action.

## Choose the artifact

- **No artifact:** direct answer, short diagnosis, or local change whose intent is
  recoverable from its commit and code.
- **One plan:** one coordinated delivery produces one observable outcome, even
  when it crosses repositories.
- **Spec plus plans:** independent deliveries must share durable architecture,
  business semantics, or a public contract, or the user explicitly asks for a
  spec.

Use project paths when defined; otherwise use
`docs/plans/YYYY-MM-DD-<slug>.md` and `docs/specs/YYYY-MM-DD-<slug>.md`. A spec
lists its child plans and each child links back.

## Minimum useful content

Omit empty sections. A plan normally contains:

```markdown
# <Outcome> Implementation Plan

> Request: "<requester's words>"

## Context
<need, verified constraints, and any bounded premise with its validation path>

## Acceptance
- **WHEN** <concrete trigger> **THEN** <observable result>

## Scope
- In: <required outcome>
- Out: <tempting adjacent work deliberately excluded>

## Binding decisions
- D1: <only a durable or costly choice; include source/date when useful>

## Delivery
1. <coherent outcome> — owner/boundary, real dependency, and observable verification
```

Split delivery at ownership, contract, independently reversible risk, or useful
verification boundaries. Keep a producer with its consumer, a schema with its
reader, and a state transition with its observable API or UI when that is the
coherent outcome. Record ordering only when changing it changes the result.

Do not prescribe internal names, file placement, libraries, control flow, routine
task decomposition, test ceremony, review choreography, or commit grouping unless
one is genuinely binding. Choose durable automated tests only for behavior that
could regress silently without another project signal; otherwise name the
appropriate direct evidence.

## Update gate

Update the artifact only when execution changes or disproves something a later
implementer must continue to honor: goal, accepted scope, acceptance, business or
data semantics, permissions, irreversible effects, public contracts, real release
order, durable dependency, or a load-bearing premise. Correct a factual premise
when leaving it would misdirect later work. Keep progress, commits, verification
results, and review history elsewhere.

## Readiness review

Start from the requester's wording. Classify proposed work as:

- **Core:** directly delivers the request.
- **Boundary or compatibility:** names a reachable trigger and the material
  consequence of not handling it.
- **Unwarranted:** lacks either half and should be deleted.

For warranted work, choose **Build** only when it carries requested value or will
be materially more expensive to add later. Otherwise **Defer** it and name the
observation that reopens it. Rank by value and cost; a valid trigger admits work
for consideration but does not put it in this release.

Then check that acceptance is observable, durable semantics are exact,
irreversible actions and dependencies are explicit, and implementation retains
freedom over reversible choices. Use an independent reviewer only when the user
asks or a high-risk durable decision benefits from fresh context.

After saving, return the path, scope classification, and proposed execution route.
Stop for confirmation unless the same request already authorized execution.
