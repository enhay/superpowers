---
name: writing-plans
description: Use only to create or update a durable implementation plan or spec, or to perform a formal implementation-readiness review of one. Do not use for planning-policy questions, narrow artifact inspection, direct answers, or routine local changes.
---

# Writing Plans

Write a durable agreement about the intended result, not a transcript or an
implementation recipe. The artifact must be **decision-complete and
implementation-open**: exact about the need and costly boundaries, silent about
reversible local choices the implementer can recover from code.

## Preconditions

Write only after the need, load-bearing facts, and binding decisions are settled
and confirmed by the user; if any remain open, use `grilling`. Do not encode an
unresolved branch as a draft or `pending` item.

The plan defines the intended result and durable constraints; code, schema,
configuration, and runtime evidence define current state; todo state and the
plan's Status define progress. A plan records authority — it does not grant
permission to push, deploy, migrate, or write production data.

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

> Request (YYYY-MM-DD): "<requester's words>"

## Need
<whose problem, in what situation, what they can do or see once it is solved, why it matters, and what stays as it is>

## Context
<verified constraints, and any bounded premise with its validation path>

## Scope
- In: <required outcome>
- Out: <tempting adjacent work deliberately excluded>

## Binding decisions
- D1: <a durable or costly choice; include source/date when useful>

## Delivery
1. <what this slice delivers, end to end> — real dependency

## Status
<where the work stands, what is open, what waits on the user>
```

The Need carries the plan: prose the requester would recognise as their own
problem, in their terms rather than the code's. Stated that way it already says
what done looks like. Acceptance for a worker is derived from it at dispatch, not
listed here.

Binding decisions say which existing structure carries the change and what is
added to it — a table, field, service, permission, compatibility path, or script
— with what the existing structure cannot carry. A rule about how the business
works, rather than what this delivery does, belongs in the project's domain
document or a spec, linked from here.

Split delivery at ownership, contract, independently reversible risk, or useful
verification boundaries — keeping a producer with its consumer, a schema with its
reader, and a state transition with its observable API or UI when that is the
coherent outcome. Record ordering only when changing it changes the result.

Execution writes only Status, overwriting it. Any other change waits for the
user, is committed on its own with its reason, and appends to the request rather
than rewriting it.

After saving, return the path and proposed execution route. Stop for
confirmation unless the same request already authorized execution.
