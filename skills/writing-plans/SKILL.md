---
name: writing-plans
description: Use only to create or update a durable implementation plan or spec, or to perform a formal implementation-readiness review of one. Do not use for planning-policy questions, narrow artifact inspection, direct answers, or routine local changes.
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
  is. Done is read from it; worker acceptance is derived at dispatch.
- **Context** keeps verified facts that would defeat the obvious approach, and
  bounded premises with how to validate them.
- **Scope Out** names tempting work deliberately excluded, including rejected
  alternatives an implementer would plausibly reach for.
- **Binding decisions** say which existing structure carries the change, what is
  added to it, and what the existing structure cannot carry. A standing business
  rule belongs in the domain document or a spec, linked from here.
- **Delivery** slices at ownership, contract, independently reversible risk, or
  verification boundaries, keeping a producer with its consumer and a schema with
  its reader. Record ordering only when changing it changes the result.

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
