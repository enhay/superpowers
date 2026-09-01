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
Record ordering only when changing it changes the result. Give each step the check
that observes its outcome **and that check's result before the change**: a check
that already passes beforehand verifies nothing, and recording the prior result is
what exposes that.

Update the artifact only when execution changes or disproves something a later
implementer must honor — goal, accepted scope, acceptance, business or data
semantics, permissions, irreversible effects, public contracts, real release
order, or a load-bearing premise. Keep progress, commits, and verification results
elsewhere.

## Readiness review

Start from the requester's wording. Work that directly delivers the request is
core. Work that adds a boundary, validation, fallback, or compatibility path must
name a reachable trigger and the material consequence of leaving it unhandled.
"A caller could", "under load", "for robustness", and "a future change might" are
not triggers; neither is the absence of a mechanism the request never asked for.
Lacking either half, delete it. For warranted work, build only what carries
requested value or will be materially more expensive to add later — otherwise
defer it and name the observation that reopens it.

Then check that acceptance is observable, durable semantics are exact,
irreversible actions and dependencies are explicit, and implementation retains
freedom over reversible choices. Use an independent reviewer only when the user
asks or a high-risk durable decision benefits from fresh context; give it the
request in the requester's own words, the plan, and the code. A trigger can only
be filled in from the inspected system, so a reviewer without it returns the
completeness review that inflates the plan.

After saving, return the path, scope classification, and proposed execution route.
Stop for confirmation unless the same request already authorized execution.
