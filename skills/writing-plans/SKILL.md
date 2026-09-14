---
name: writing-plans
description: Use only to create or update a durable implementation plan or spec, or to perform a formal implementation-readiness review of one. Do not use for planning-policy questions, narrow artifact inspection, direct answers, or routine local changes.
---

# Writing Plans

Write a durable agreement about the intended result, not a transcript or an
implementation recipe. The artifact must be **decision-complete and
implementation-open**: exact about observable outcomes and costly boundaries,
silent about reversible local choices the implementer can recover from code.

## Preconditions

Write only after the need, load-bearing facts, binding decisions, and acceptance
are settled and confirmed by the user; if any remain open, use `grilling`. Do not
encode an unresolved branch as a draft or `pending` item.

The plan defines the intended result and durable constraints; code, schema,
configuration, and runtime evidence define current state; todo state, commits, and
reviews define progress. A plan records authority — it does not grant permission
to push, deploy, migrate, or write production data.

## The artifact

One coordinated delivery producing one observable outcome gets one plan, even when
it crosses repositories. Add a spec above the plans only when independent
deliveries must share durable architecture, business semantics, or a public
contract, or the user asks. Use project paths when defined, otherwise
`docs/plans/YYYY-MM-DD-<slug>.md` and `docs/specs/YYYY-MM-DD-<slug>.md`; a spec
lists its child plans and each child links back.

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

Write the need so it still holds if the codebase were deleted. Split delivery at
ownership, contract, independently reversible risk, or useful verification
boundaries — keeping a producer with its consumer, a schema with its reader, and a
state transition with its observable API or UI when that is the coherent outcome.
Record ordering only when changing it changes the result. Give each step the
lightest check that observes its accepted outcome; this need not be a new test.
For a bug fix, identify the prior failure when feasible. For behavior-preserving
refactoring or cleanup, existing checks passing before and after are useful
regression evidence. Derive checks from current acceptance, not deleted
implementation details; retiring logic does not create a requirement to test its
absence or invert its old assertions. Follow the global rules for test lifecycle
and TDD. Keep actual run results with execution evidence, not in the plan.

Update the artifact only when execution changes or disproves something a later
implementer must honor — goal, accepted scope, acceptance, business or data
semantics, permissions, irreversible effects, public contracts, real release
order, or a load-bearing premise. Keep progress, commits, and verification results
elsewhere.

After saving, return the path and proposed execution route. Stop for
confirmation unless the same request already authorized execution.
