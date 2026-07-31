---
name: writing-plans
description: Use only when a durable implementation plan must be written or updated, or when a formal implementation-readiness review of a plan/spec is itself the requested deliverable. Do not use to decide whether planning is needed, explain planning policy, inspect why plan/spec files exist, or answer a narrow question about an artifact.
---

# Writing Plans

Turn verified requirements and current code facts into durable decision context
for implementation. A plan has two readers and must serve both. A person reviews
it: it reads as a product document and a technical proposal, saying what problem
is being solved, what changes for the user, and why this approach. An implementer
executes it: it is **decision-complete and implementation-open** — no need to
invent business semantics, public contracts, or irreversible choices, but free to
choose reversible local implementation. Several steps is not a trigger; trivial
and small work stays on `inspect -> implement -> verify`.

Not a trigger: discussing whether a plan is warranted, explaining the workflow,
asking why two documents exist, or fact-checking an existing document. Those stay
on `inspect -> answer`. The user saying "plan" or "spec" is not by itself a trigger.

## Artifact route

Choose from the delivery shape, not the technical topic, in order:

1. **No artifact** — local change, direct answer, short diagnosis.
2. **One plan** — one team owns one observable outcome released through one
   coordinated path. Still true when it spans repositories or involves UX, data
   semantics, architecture, or public interfaces. Those topics never force a spec.
3. **Spec then plans** — only when two or more independently reviewable plans need
   the same durable architecture, business semantics, or public contract before
   they can be split, or when the user explicitly asks for a spec.

File, repository, service, screen, and open-question counts do not select the spec
route. If one plan can carry the decision, acceptance, tasks, and verification,
keep it there and update that plan as it sharpens.

Plans: `docs/plans/YYYY-MM-DD-<slug>.md`. Specs: `docs/specs/YYYY-MM-DD-<slug>.md`.
User or project instructions override these paths. A spec must not duplicate one
plan's task list, file inventory, or acceptance.

A spec and its plans reference each other, and neither direction is optional. The
spec lists every plan it governs; each plan names its spec in the header. A
one-way link answers neither question that actually comes up: which plans a
changed spec decision invalidates, and where a plan's disproved premise has to be
written back. Register the plan in the spec when the plan is created, not when it
finishes — a list assembled at the end is stale for the whole execution.

## Before writing

Size the request first. If it describes several independent subsystems, say so
before refining any of them — decomposition costs one exchange, while refining a
request that has to be split wastes every question asked. Name the independent
pieces, how they relate, and a build order, then plan only the first one; each
later piece gets its own plan when its turn comes.

Then separate the core need from everything else, and plan the core need. The
core need is the smallest form that delivers value: what the business can do once
only that ships. Anything outside it — degradation and fallback, high
availability and automatic recovery, compatibility layers, projection and
materialization machinery, and their kin — is neither yours to add nor yours to
defer. Each is an architecture decision: name it, say what it buys and what
breaks without it, and ask. No answer means out of scope. These are the
capabilities a complete-looking engineering plan carries by default, which is
exactly why they arrive unexamined; a plan that quietly includes one has made a
decision the user never saw.

Then inspect the real code, entrypoints, consumers, tests, and existing documents
far enough to verify the load-bearing facts. Separate established requirements
from assumptions. Do not exhaustively predict files, functions, or implementation
steps only to make the plan look executable; the implementer will inspect the
local path again with fresher evidence. Anything the code, the data, or an
existing document can settle is yours to settle, never to ask. Ask one
consolidated question only when the user must choose before a final contract can
be stated, and carry your recommended answer in it — a question without one hands
the work back. Otherwise make the uncertainty the first bounded task and keep the
plan live. Do not manufacture alternatives to look thorough.

When the user asks to be interrogated on the plan, switch modes: one question at
a time, each about direction — goal, boundary, trade-off — never implementation,
each grounded in a fact you looked up rather than a gap you noticed, and each
carrying your recommended answer. Wait for the answer before opening the next
branch, and write nothing until the user says the picture is shared.

## Plan for the observed system

When internal producers and consumers ship together, default to one final
contract, one coordinated release, the smallest necessary deploy order, and one
end-to-end check through the real consumer path.

Do not add distributed locks, generalized retries, dual read/write, version
matrices, staged rollout, canary gates, or long-lived compatibility because
several services are involved. Locks and idempotency require named contending
writers or duplicate delivery. Compatibility and staged rollout require an
independently released or external consumer. Recovery planning requires a
genuinely irreversible data, permission, or financial operation. Low traffic does
not disprove a real race — a named contention point still deserves an explicit
invariant.

## Decision boundary

The plan owns decisions whose reinterpretation would change the delivered product
or make later work expensive to reverse:

- observable goal and acceptance;
- user decisions and business semantics;
- data ownership, migration destination, permissions, and irreversible effects;
- public, external, or cross-team contracts and independently released consumers;
- real ordering constraints and the evidence that proves the outcome.

Implementation owns reversible local choices: internal names and signatures,
exact file placement, library choice, control-flow shape, local decomposition,
worker/model selection, review choreography, and commit grouping. Freeze one of
those only when the user chose it, existing wiring makes it binding, several
delivery slices must coordinate on it, or changing it later has material cost.
State that reason with the decision.

The test is not whether the plan can describe a detail, but whether leaving it to
a capable implementer would force a product, contract, data, permission, or
irreversible decision. If not, describe the outcome and responsibility boundary,
then stop.

## Structure

```markdown
# [Feature] Implementation Plan

**Spec:** `docs/specs/...` — only when a spec governs this plan, and only if that
spec lists this plan back.
**Background:** current state, what is wrong with it, and why it is worth doing
now. A load-bearing claim about how the system is today carries the command or
query that established it, so a later reader can re-run it instead of trusting
it. Mark what is still inference or a bounded premise to prove.
**Goal:** one sentence, observable outcome.
**Core need:** the smallest form that delivers value — what the business can do
when only this ships, and what it still lacks. Current and foreseeable volume
belongs here: it is the input that decides whether any mechanism below is worth
its cost, and without it "too heavy" cannot be judged at all.
**Acceptance:** concrete conditions that prove the goal is met.
**Architecture:** the approach and its durable boundaries, a few sentences.

## Binding decisions
- **D1** decision from the user, a verified contract, project rules, or the
  governing spec; include why it is binding when that is not obvious, and the
  fact it rests on when someone will later ask why — written as history, with a
  date and how it was checked ("2026-07-31: only `worker.ts:42` writes this
  table — `rg -n 'insertOrder' src/`"), never as a standing claim about the
  system.

## Delivery slices
### Task N: [coherent outcome]
**Outcome:** observable behavior this slice completes.
**Scope:** responsibility boundary; name repositories or components only when
ownership or integration depends on it.
**Depends on:** only a real predecessor or external prerequisite; omit otherwise.
**Binding decisions:** D1, D3, each with the two or three words that name it —
only decisions this slice must not reinterpret. Names save the reader a jump back;
the exact values stay in the list above so they cannot drift between copies.
**Contract:** exact shape only for a public, external, or cross-slice interface;
omit internal signatures and names.
**Known path:** files or entrypoints only when existing wiring, ownership, or a
migration makes the location consequential.
**Verification:** smallest direct evidence that proves this outcome. Specify a
test only when a later change would break the behavior silently AND that break
would surface nowhere else; otherwise a one-time observation is the deliverable.
**Implementation note:** optional; one non-obvious fact costly to rediscover, not
a prescribed method.
```

Binding decisions are few and durable. Number them only when more than one slice
must refer to the same decision; a one-slice fact can live in that slice. Do not
promote repository conventions or normal engineering judgment into plan
constraints. A decision listed globally but referenced nowhere is either context
or ceremony — move or delete it. Where no alternative was ever available, there
was no decision to record: state it as a fact in Background instead.

Tense is what keeps a record from going stale. A decision's basis is history and
stays true forever; a claim about how the system is today expires silently and
poisons whoever reads it next. Write each as what it is. When a later decision
overturns a recorded one, mark the old entry superseded in place and leave its
text alone — it is why the code looks the way it does, and deleting it leaves
every reference to it dangling.

Correcting a fact that turns out to be wrong needs no permission — correct it,
with the evidence. But when that fact was a decision's recorded basis, the
decision has lost its support rather than been overruled: take the user the
disproved basis, what it was carrying, and your recommendation.

A fact established by an earlier plan is referenced by that plan's path, never
copied in: a copy cannot be corrected when the original is. Before resting on
something that plan states in the present tense, re-run its check, or say you did
not and are proceeding on inference.

A task is a coherent delivery slice, not a promise of one dispatch, one commit, or
one review. Usually keep a producer with its consumers, a schema change with its
readers, or a state transition with the UI/API path that observes it. Split where
there is a real dependency, ownership boundary, independently reversible risk, or
useful verification point. Do not split merely to manufacture isolated diffs.

The execution controller may merge adjacent slices, split an unexpectedly large
one, keep tightly coupled work with one agent, or delegate a bounded subset after
reading the code. That does not require rewriting the plan unless the goal,
acceptance, binding decision, contract, or durable dependency changes.

Do not prescribe the steps inside a task. The implementer reads the code first and
decomposes better than you can from outside; a step list written without that
reading is a guess you then maintain. State an ordering requirement only when
getting it wrong breaks something — and then it is a binding decision, not a
generic sequence.

Splitting a task in two can create an interface that exists only for the plan. Do
not create that interface: keep the work together and let execution choose its
internal decomposition.

A plan never creates push, deploy, migration, or production-write authority by
existing or being approved. Record such permission once only when the user or
project explicitly grants it; omission means no authority. Local commits are not
in that class — they are revertible, they leave nothing, and execution needs them
to have review and rollback boundaries at all; they need no grant. Never add
per-task commit choreography to the plan either way: where the boundaries fall is
execution's choice.

When execution disproves one of the plan's premises, correct it where the premise
lives and carry the consequence to the user. Rejected alternatives, adjudications,
progress, review verdicts, and how the built interfaces differed from the planned
ones do not belong in the plan: the first two load discarded designs into the
implementer's context, and the rest stop mattering when the code lands. Durable
rationale belongs in the spec; execution history belongs in the ledger.

## Keep out of the plan

Complete implementation functions or routine test bodies; mandatory red-green
steps; ceremonial rollout, migration, or governance without real production risk;
speculative concurrency work without named call sites; compatibility layers when
all callers ship together; **rejected alternatives and mechanisms decided
against** — a plan states what to build, and naming what it does not build loads
those designs into the implementer's context, marks them as seriously considered,
and sets the granularity at which he will weigh his own forks; dependency
diagrams when a contract plus deploy order plus consumer check already describe
the change; a spec restating one plan;
exact internal signatures, file lists, or names with no contract or ownership
reason; agent/model assignment; dispatch, review, or commit choreography;
`TBD`/`add suitable tests` placeholders; context already recorded elsewhere;
prose that neither constrains execution nor helps a reader understand the change.

Conversation residue is the common failure in a plan revised across exchanges:
one decision restated in three sections, rebuttals to proposals no task would
implement, sentences addressed to the current conversation ("what you gave me is
not authorization for X"). Test each line three ways — does a reader need it to
understand the change, does the approver need it to decide, does the implementer
need it to execute? None of the three means it is a transcript, not a plan.

A compact pseudocode fragment or exact invariant is allowed when the
implementation shape is itself the decision — critical algorithms, data semantics,
permission rules, public contracts.

## Reviewing a plan or spec

Use before handing off your own plan, and as the checklist when asked to review
someone else's. A plan is not a code change: review decisions and omissions, not
wording or hypothetical implementation quality. The main agent owns adjudication;
an independent reviewer is useful when the user asks for one or when a high-risk
decision benefits from a fresh pass. Give that reviewer the plan and source
evidence, not your intended verdict. Review what is expensive to reverse and
invisible in a later diff:

1. **Core need and proportion** — which slices does the core need actually
   require? Take one away: does the business still run? Any capability outside
   the core need that was added rather than asked about — degradation, high
   availability, compatibility, projection machinery — is a finding, and so is a
   mechanism that is whole-block too heavy for the stated volume. Ask this first:
   after eleven local checks the reviewer is inside the details and will not come
   back out, and every finding produced there argues for keeping the thing it
   found a flaw in. Too heavy for the problem is a finding in both directions.
2. **Artifact fit** — does one plan own one outcome; does an existing spec govern
   more than one plan; do spec and plan name each other?
3. **Premises** — which load-bearing facts were verified against real data, which
   are inference, and which were inherited from an older document without being
   re-checked?
4. **Falsifiable acceptance** — what observation decides success, and what would
   failure look like?
5. **Boundaries and contracts** — data ownership, call direction, final interface
   shapes, and which external callers cannot change in this release. A
   representable state is not a contract obligation: a proposed boundary,
   validation, failure behavior, or compatibility path needs both a reachable
   source and a consequential outcome, or the established invariant stands.
6. **Data semantics** — denominators, time windows, join keys, exclusions pinned
   exactly. Wrong calibration passes every test.
7. **State and migration** — what happens to existing data, whether one bounded
   migration reaches the correct final model, whether legacy fields are removed.
   Coexistence needs a named caller that cannot ship together, plus an exit
   condition.
8. **Concurrency and failure handling** — every lock, retry, timeout, fallback, or
   compensation names its real trigger. Service count and future load are not
   evidence.
9. **Permissions and PII** — who sees what, tenant isolation, which fields reach
   user-visible output.
10. **Irreversible points** — where explicit approval and stronger verification
   belong, instead of spreading them evenly.
11. **Delivery coherence** — hidden ordering, artificial interfaces created only
    to split work, or responsibility boundaries that cannot be owned safely.
12. **Implementation freedom** — details frozen without a contract, coordination,
    evidence, or reversal-cost reason; or business decisions wrongly left to the
    implementer.
13. **Implicit decisions and ambiguity** — business choices the plan made quietly
    (a threshold, a default, a calibration), and any requirement that can be read
    two ways. Pick one reading and state it.

Also confirm every acceptance condition has a delivery path, binding contracts
are internally consistent, stale tasks are removed, verification matches risk
rather than habit, and a reader who was not in the conversation can tell what
problem is being solved and why this approach.

Out of scope: wording, formatting, execution-level detail (naming, library choice,
decomposition), and demands to enumerate every edge case.

## After saving

Return only a concise summary, the path, and the proposed execution route. Use
`subagent-driven-development` when one or more slices have clear responsibility
boundaries and fresh worker context or delegation has real value. Hand workers the
plan path plus a task-local brief containing the outcome, scope, relevant
binding-decision IDs, known dependencies, and verification — not a rewritten
implementation recipe or the whole conversation. Exact decision values stay in
the plan so they cannot drift between copies.

When delegation adds no value and the user did not explicitly request it, execute
the plan directly in the current session. Inspect the current code, choose
reversible local implementation, merge or split delivery slices when useful, and
verify their outcomes plus final acceptance. Do not create SDD briefs, ledgers,
review packages, or per-task review ceremony for this route. Add independent
review only when the user asks or the change's risk justifies it. If the user
already asked to implement, start without asking them to choose again.
