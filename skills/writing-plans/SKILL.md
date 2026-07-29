---
name: writing-plans
description: Use only when a durable implementation plan must be written or updated, or when a formal implementation-readiness review of a plan/spec is itself the requested deliverable. Do not use to decide whether planning is needed, explain planning policy, inspect why plan/spec files exist, or answer a narrow question about an artifact.
---

# Writing Plans

Turn verified requirements and current code facts into a durable plan at contract
level. Several steps is not a trigger; trivial and small work stays on
`inspect -> implement -> verify`.

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

## Before writing

Size the request first. If it describes several independent subsystems, say so
before refining any of them — decomposition costs one exchange, while refining a
request that has to be split wastes every question asked. Name the independent
pieces, how they relate, and a build order, then plan only the first one; each
later piece gets its own plan when its turn comes.

Then inspect the real code, entrypoints, consumers, tests, and existing documents.
Separate established requirements from assumptions. Ask one consolidated question
only when the user must choose before a final contract can be stated; otherwise
make the uncertainty the first bounded task and keep the plan live. Do not
manufacture alternatives to look thorough.

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

## Structure

```markdown
# [Feature] Implementation Plan

**Goal:** one sentence, observable outcome.
**Acceptance:** concrete conditions that prove the goal is met.
**Architecture:** chosen approach and important boundaries, a few sentences.
**Global constraints:** exact cross-task requirements from user decisions,
verified code contracts, project rules, or a spec's binding decisions only.

## File structure
- `path/to/file`: responsibility and why it changes

## Tasks
### Task N: [reviewable deliverable]
**Files:** created or modified.
**Interfaces:** exact signatures, payload shapes, names, invariants in and out.
**Deliverable:** the observable behavior completed by the task.
**Implementation notes:** only what the implementer must not rediscover.
**Verification:** smallest direct evidence that proves this task works.
**Commit boundary:** required if this plan will use subagent-driven-development.
```

A task is the smallest unit that produces an independently observable result, can
be reviewed without accepting its neighbors, carries its own setup and
verification, and names the interfaces later tasks rely on. Split by deliverable,
not by technical layer.

## Keep out of the plan

Complete implementation functions or routine test bodies; mandatory red-green
steps; ceremonial rollout, migration, or governance without real production risk;
speculative concurrency work without named call sites; compatibility layers when
all callers ship together; dependency diagrams when a contract plus deploy order
plus consumer check already describe the change; a spec restating one plan;
`TBD`/`add suitable tests` placeholders; context already recorded elsewhere; prose
that constrains nothing.

A compact pseudocode fragment or exact invariant is allowed when the
implementation shape is itself the decision — critical algorithms, data semantics,
permission rules, public contracts.

## Reviewing a plan or spec

Use before handing off your own plan, and as the checklist when asked to review
someone else's. A plan is not a code change — read it and respond directly, never
dispatch a reviewer subagent. Review only what is expensive to reverse and
invisible in a later diff:

1. **Artifact fit** — does one plan own one outcome; does an existing spec govern
   more than one plan?
2. **Premises** — which load-bearing facts were verified against real data, and
   which are inference?
3. **Falsifiable acceptance** — what observation decides success, and what would
   failure look like?
4. **Boundaries and contracts** — data ownership, call direction, final interface
   shapes, and which external callers cannot change in this release. A
   representable state is not a contract obligation: a proposed boundary,
   validation, failure behavior, or compatibility path needs both a reachable
   source and a consequential outcome, or the established invariant stands.
5. **Data semantics** — denominators, time windows, join keys, exclusions pinned
   exactly. Wrong calibration passes every test.
6. **State and migration** — what happens to existing data, whether one bounded
   migration reaches the correct final model, whether legacy fields are removed.
   Coexistence needs a named caller that cannot ship together, plus an exit
   condition.
7. **Concurrency and failure handling** — every lock, retry, timeout, fallback, or
   compensation names its real trigger. Service count and future load are not
   evidence.
8. **Permissions and PII** — who sees what, tenant isolation, which fields reach
   user-visible output.
9. **Irreversible points** — where commit boundaries and stronger verification
   belong, instead of spreading them evenly.
10. **Task independence** — hidden ordering, or two tasks editing one file.
11. **Proportion** — too heavy for the problem is a finding, in both directions.
12. **Implicit decisions and ambiguity** — business choices the plan made quietly
    (a threshold, a default, a calibration), and any requirement that can be read
    two ways. Pick one reading and state it.

Also confirm every acceptance condition maps to a task, interfaces and names are
consistent, stale tasks are removed, and verification matches risk rather than
habit.

Out of scope: wording, formatting, execution-level detail (naming, library choice,
decomposition), and demands to enumerate every edge case.

## After saving

Return only a concise summary, the path, and the execution route. Use
`subagent-driven-development` when tasks are independently implementable and the
plan authorizes task-level commits; otherwise execute directly on the main line.
If the user already asked to implement, start without asking them to choose again.
