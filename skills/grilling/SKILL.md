---
name: grilling
description: Use before writing a durable plan or spec when the need, load-bearing facts, or binding decisions are unsettled. Also use when the user asks to be interviewed or to stress-test an idea. Conversation only; never creates or edits files.
---

# Grilling

Reach shared understanding before any durable artifact is written. Do not create
or edit a plan, spec, decision log, or notes while this skill is active.

## The need

Take the need from the request or the user. Inspection tells you what constrains
the need and what it costs, never what the need is: a need discovered by reading
code — "the system lacks X" — describes the code, not anyone's goal. If the
request contains independent outcomes, separate them before refining the first.

Inspect authoritative sources for facts instead of asking the user to rediscover
them. Trace each decision to an existing user statement, or ask.

## Ask only binding questions

The user decides the goal and acceptance, business semantics, data ownership and
migration destination, permissions, irreversible effects, public or cross-team
contracts, and ordering constraints that change the result.

Resolve reversible choices from the current system: internal names, files,
libraries, control flow, local decomposition, worker choice, review choreography,
and commit grouping. Do not turn those into questions unless coordination or
reversal cost makes one binding.

Before asking for a new boundary, validation, fallback, or compatibility path,
establish both its reachable trigger and the material consequence of leaving it
unhandled. Technical possibility alone is not a decision: "the network can fail"
is reachable, but "a few telemetry events are lost" is not a consequence worth a
mechanism, so the retry queue it appears to justify never becomes a question. An
unwarranted item put to the user tends to come back as a yes — asking implies it
was worth considering.

New structure passes the same test. Start the recommendation from the existing
structure that can carry the need; a new table, field, service, permission,
configuration, or layer is justified only by what the existing one cannot carry,
and that reason belongs in the question. The costlier shape proposed first is the
one the user has to argue down.

Ask the currently answerable questions in one numbered round, each with a
recommended answer and its material tradeoff. The user decides by consequence, so
state each question as the business situation and what each answer makes happen.
A question that needs the code, or a label you coined, to be understood is one
you have not finished resolving. Do not ask a question whose answer
depends on another still pending; recompute the next round after the user
responds. Investigate missing environmental facts in parallel with the questions
that do not depend on them.

## Finish

Summarize the need as the plan will state it, in the user's terms; the verified
facts, bounded premises, and material unknowns; each
binding decision and its chosen value; which existing structure carries the
change and what is added to it; and any unknown that still blocks a decision. Ask
the user to confirm, then stop.
