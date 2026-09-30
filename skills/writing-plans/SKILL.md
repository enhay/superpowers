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

## Context
<need, verified constraints, and any bounded premise with its validation path>

## Acceptance
- <what the requester checks to call it done, and where it shows>

## Scope
- In: <required outcome>
- Out: <tempting adjacent work deliberately excluded>

## Structure
- Carried by: <the existing structure the outcome lives in>
- Added: <each new table, field, service, permission, configuration, compatibility path, or script, and what the existing structure cannot carry>

## Binding decisions
- D1: <only a durable or costly choice; include source/date when useful>

## Delivery
1. <coherent outcome> — owner/boundary, real dependency, and observable verification

## Status
<where the work stands, what is open, what waits on the user>
```

Structure is answered for every change to code or data, even when the answer is
that nothing is added: it is where costly shape gets decided, and an implementer
who finds it blank adds shape of their own. Diagrams of the existing system and
restated code do not belong there — the code already defines current state.

A rule that says how the business works, rather than what this delivery does,
outlives the plan. Put it in the project's domain document or a spec when writing
and link to it; kept in the plan, it vanishes when the plan is retired and every
later plan restates it.

Acceptance is what the requester will check to call the work done, in their
terms, each item with where it shows — a page, an API field, a stored row, a
replay on real data. Give a behavior that starts from an event its trigger; state
a property that always holds as a property rather than inventing a trigger for
it. Rules about how the business works are not acceptance, and neither is a named
sample: the executor reads every item as something to test and fits its work to
any sample it is shown. An acceptance list running to dozens of items has usually
absorbed those rules.

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
and TDD.

Request, Acceptance, Scope, Structure, and Binding decisions are the agreement.
The Request quotes the requester and is never rewritten; a later request is
appended with its date, because the original words are what every later reader
checks the plan against. When execution finds the agreement wrong, incomplete, or
overtaken, record the conflict in Status and continue only the work it does not
touch; the agreement changes once the user confirms, with that date on the
changed item. Context and Delivery may be corrected against evidence without
asking. Any change outside Status is committed on its own, its message naming what
changed and why: git is the plan's history, and a revision folded into a code
commit leaves none that anyone will find.

Status is the part execution writes freely: where the work stands, what is open,
what waits on the user. Overwrite it — it is a snapshot for whoever resumes, not a
log. Run results stay with execution evidence, linked from Status.

After saving, return the path and proposed execution route. Stop for
confirmation unless the same request already authorized execution.
