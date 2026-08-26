---
name: grilling
description: Use before writing a durable plan or spec when the need, load-bearing facts, or binding decisions are unsettled. Also use when the user asks to be interviewed or to stress-test an idea. Conversation only; never creates or edits files.
---

# Grilling

Reach shared understanding before any durable artifact is written. Do not create
or edit a plan, spec, decision log, or notes while this skill is active.

## Establish the frame

Identify who needs to do what, what prevents it today, and what observable result
would count as success. If the request contains independent outcomes, separate
them before refining the first one.

Keep facts and decisions distinct:

- **Facts** describe the current code, data, runtime, protocol, or operating
  conditions. Inspect authoritative sources instead of asking the user to
  rediscover them. Label material claims as verified fact, derived inference,
  bounded premise, or unknown.
- **Decisions** choose the intended outcome or a costly boundary. Trace them to
  an existing user statement or ask the user.

## Ask only binding questions

The user decides the goal and acceptance, business semantics, data ownership and
migration destination, permissions, irreversible effects, public or cross-team
contracts, and ordering constraints that change the result.

Resolve reversible implementation choices from the current system: internal
names, files, libraries, control flow, local decomposition, worker choice, review
choreography, and commit grouping. Do not turn those into interview questions
unless coordination or reversal cost makes one binding.

Before asking for a new boundary, validation, fallback, or compatibility path,
establish both its reachable trigger and the material consequence of leaving it
unhandled. Technical possibility alone is not a decision.

Ask the currently answerable questions in one numbered round. Give one
recommended answer and its material tradeoff for each. Do not ask a question
whose answer depends on another answer still pending; recompute the next round
after the user responds. Investigate missing environmental facts in parallel with
the questions that do not depend on them.

## Finish

When no binding question remains, summarize:

- verified facts, inferences, bounded premises, and material unknowns;
- each binding decision and its chosen value;
- any unknown that still blocks a decision and the evidence needed to resolve it.

Ask the user to confirm that understanding, then stop. After confirmation,
`writing-plans` may write a durable artifact, or implementation may begin directly
when no document is needed.
