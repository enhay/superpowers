---
name: writing-plans
description: Use only to create or update a durable implementation plan or spec, to review one for implementation readiness, or to review an implementation against its plan, spec, or documented architecture constraints. Do not use for planning-policy questions, narrow artifact inspection, direct answers, or routine local changes.
---

# Writing Plans

A plan or spec is the requirement as understood after discussion: what an
implementer needs to deliver the right result without guessing, and nothing it
can recover from the code.

## Guidance

- **Depth.** Decision-complete, implementation-open: refine each item until no
  costly branch is left for the implementer to guess, then stop. Reversible local
  choices stay out.
- **Shape.** One coordinated delivery with one observable outcome gets one plan,
  even across repositories. Add a spec above plans only when independent
  deliveries share architecture, business semantics, or a public contract, or
  the user asks; the spec lists its plans and each links back. Use project paths,
  otherwise `docs/plans/` or `docs/specs/` with `YYYY-MM-DD-<slug>.md`.
- **Need** carries the plan: the requester's problem in their terms — who, in
  what situation, what they can do once it is solved, why, and what stays as it
  is. Done is read from it; worker acceptance is derived at dispatch. When the
  request lives in a durable source — an issue, a PRD, a ticket — link it; the
  Need stays binding, and any deliberate departure from the source is stated in
  Scope Out or a decision.
- **Context** keeps verified facts that would defeat the obvious approach, and
  bounded premises with how to validate them.
- **Scope Out** names tempting work deliberately excluded, including rejected
  alternatives an implementer would plausibly reach for.
- **Binding decisions** say which existing structure carries the change, what is
  added to it, and what the existing structure cannot carry. A standing business
  rule belongs in the domain document or a spec, linked from here. An
  architecture-level change, as [architecture.md](architecture.md) defines it,
  answers its design questions here.
- **Delivery** slices at ownership, contract, independently reversible risk, or
  verification boundaries, keeping a producer with its consumer and a schema with
  its reader. Record ordering only when changing it changes the result.
- **Checkpoints.** When the user wants control, end each slice at a result they
  can observe without reading code, put the slice that could overturn the rest
  first, cut finer before costly or irreversible steps, and mark where execution
  stops for their review. A checkpoint judges the result against the plan, as
  in Reviewing an implementation, not the slice's own check.

Omit empty sections:

```markdown
# <Outcome> Implementation Plan

## Need
## Context
## Scope
- In:
- Out:
## Binding decisions
- D1:
## Delivery
1. <what this slice delivers, end to end> — real dependency
## Status
<where the work stands and what waits on the user; overwritten, not appended>
```

## Reviewing a plan

A plan cannot be run, and every slice inherits its mistakes. Read it yourself
and look only for what is costly to reverse once built and invisible in a
later diff:

- **Premises.** Which facts in Context and the decisions were checked against
  code or data, and which are inference? A false load-bearing premise sinks the
  whole plan.
- **Need.** Name the observation that decides done, and what failure would look
  like. If you cannot, the Need is too vague to accept against.
- **Implicit decisions.** Find the business choices the plan made without the
  user: a threshold, a default, a calibration, a permission outcome. Each one
  goes back to `grilling`, not into the plan.
- **Coverage.** Every costly branch — contract shape, data semantics, existing
  data, permissions, irreversible steps — is decided; a missing one is a
  finding. A decision that only fixes a reversible local choice is too, and so
  is an architecture-level change without its design questions answered.
- **Delivery.** Hidden ordering, two slices in one module, or an irreversible
  step with no checkpoint before it.
- **Proportion.** A plan too heavy or too light for its problem is a finding.

Leave wording, naming, library choice, and edge-case enumeration to execution.

## Reviewing an implementation

Pin the diff range, then read the plan if one governs and the architecture and
coding standards the project instructions name. Quote the source in each
finding — the plan's Need, Scope Out, or decision ID, or the standard's rule.
The first three questions need a plan; the fourth always applies:

1. **Missing or partial.** What the Need promised that is not delivered.
   Observe it on the real consumer path; reading the diff does not show it.
2. **Beyond the plan.** Behavior nothing in the plan asked for, or anything
   Scope Out excluded.
3. **Against a decision.** A binding decision carried by a different structure
   than it names, or with something it did not add. Read the code here; a
   passing check does not show it.
4. **Against a standard.** A constraint the diff breaks, from
   [architecture.md](architecture.md) — its review signals first — and the
   project's own documents. The project's rule wins over both the general one
   and taste; a recorded deviation is not a finding.

When code departs from the plan because the plan was wrong, the finding is a
plan change for the user, never a silent acceptance or a fix that makes the
code match a wrong plan; the same holds for a standard. Report plan, standard,
and bug findings as separate groups, so one does not mask another.

## Constraints

1. Write only after the user has confirmed the need and binding decisions;
   otherwise use `grilling`. Never encode an open branch as a draft or `pending`.
2. Write the current state from your understanding, not a record of the
   conversation: no quotes, agent-directed instructions, superseded positions,
   or references only the conversation resolves. Rewrite changes in place; never
   reuse or mention a removed decision ID.
3. Each fact lives in one section; no acceptance list.
4. After saving, return the path and the proposed execution route, then stop
   unless the same request authorized execution. A plan authorizes no push,
   deploy, migration, or production write.
