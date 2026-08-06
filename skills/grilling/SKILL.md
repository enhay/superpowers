---
name: grilling
description: Use when a durable plan or spec is about to be written and the need, its load-bearing facts, or its binding decisions are not yet settled — the interview that has to happen first. Also use when the user asks to be grilled or interviewed, or to have an idea, design, or decision stress-tested. Produces conversation only, never a file.
---

# Grilling

Interview until the need, the facts that constrain it, and every decision that
binds the outcome are settled. What this produces is a shared understanding held
in the conversation. The document comes afterwards, written in one pass by
whoever owns the artifact.

Write nothing while grilling — no plan, no spec, no design note, no section
holding decisions that are still open. An unsettled decision written down reads as
settled, and no later reader can tell the difference.

## Size the request first

Establish what is being asked for before refining any part of it. A request
describing several independent subsystems needs decomposing before it needs
questions; questions spent sharpening one corner of a request that should have
been three are wasted. Say so as soon as you see it, and grill the first piece.

Establish the need before inspecting: who wants to do what, and what stops them
today. Take it from the request, or ask. Inspection tells you what constrains the
need and what it costs — it does not tell you what the need is. A need discovered
by reading code is a description of the code.

## Two sets, kept apart

**Facts** are observable current-state claims about the code, data, runtime,
external protocol, or operating conditions. Finding them is your job. Verify them
from the environment or an authoritative source; ask the user only for a fact
they uniquely own.

**Decisions** choose the intended outcome or bind anything under Decision
boundary below. They are the user's. Trace each one to an existing user statement
or put it to them.

Mixing the two fails in two directions: the user is asked to rediscover something
already sitting in their own repository, or a choice they own is quietly resolved
by whatever the code happens to do today.

Within the facts set, label each item's epistemic status instead of flattening
all current-state language into fact:

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

## Work the frontier

Decisions branch: settling one opens the ones that hang off it. The **frontier**
is every decision whose prerequisites are already settled — the questions
answerable now, without guessing at answers you have not heard.

Ask the whole frontier in one round. Number each question and carry one
recommended answer with its material consequence. A question whose answer depends
on another still open in this round belongs to a later round: batching dependent
questions forces the user to answer hypothetically, and those answers then have
to be revisited.

Each answer reshapes the tree. Recompute the frontier and ask the next round.

When a frontier question needs a fact from the environment, go find it rather
than asking. Do not block the round on it — a running investigation is an
unsettled prerequisite, so only the questions downstream of it wait. Ask the rest
of the frontier now.

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
implementation unless coordination or reversal cost makes one binding. Resolve
these from code and repository conventions and keep them out of the interview
entirely. A repository convention can resolve a reversible implementation choice,
but cannot stand in for a product decision.

## Warrant before asking

Before putting a boundary, validation, error-handling, or compatibility item to
the user, settle the warrant it would have to carry: the state that is actually
reachable, **and** the consequence of leaving it unhandled. Both halves, or it
never becomes a question. "The network can fail" is reachable; "a few telemetry
events are lost" is usually not a consequence worth fixing, so the retry queue it
appears to justify does not enter the decision set.

An unwarranted item that reaches the user as a question tends to come back as a
yes. Asking implies it was worth considering, and the user has no reason to
suspect the warrant was never checked.

## When conversation cannot settle it

Some questions have no answer on paper: whether a state model actually holds up,
what something should look like. Detour through a throwaway prototype, bring the
answer back, and continue the frontier from there. The prototype answers one
question; it is neither the design nor the plan.

## Done

The session ends when the frontier is empty: every branch visited, nothing
silently assumed. Present the result before anything is written:

- fact items grouped as verified facts, derived inferences, bounded premises, and
  material unknowns;
- each decision and what it was settled to.

An unknown blocks the work only when resolving it could change a binding
decision; otherwise state its boundary and leave it open.

Then stop and wait. A shared understanding is something the user confirms, not
something you declare. Only after they confirm does an artifact get written — by
writing-plans when a durable plan or spec is the deliverable, or directly in code
when the delivery shape needs no document.
