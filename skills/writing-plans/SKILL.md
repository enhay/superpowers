---
name: writing-plans
description: Use when a medium or larger task needs a durable implementation plan before code changes, when the user explicitly asks for a plan, or when the user asks to review or critique an existing plan or spec. Skip trivial and small tasks that can be completed directly.
---

# Writing Plans

## Purpose

Turn verified requirements and current code facts into a durable implementation plan. Keep the plan at contract level so a capable main agent or worker can implement it without copying speculative code from the planning stage.

Do not use this skill merely because a task has several steps. Trivial and small work stays on the direct `inspect -> implement -> verify` path.

## Artifact Escalation

Choose the smallest durable artifact that fits the work:

- **Commit-level change:** The change is local and its intent can be explained in a commit message. Do not create a plan or spec.
- **One implementation plan:** The requirements are established, but the work spans multiple reviewable tasks. Write one plan.
- **Spec then plans:** Architecture, UX, data semantics, public interfaces, or genuinely independent product subsystems still need durable decisions. Write or update a spec first, then create one or more plans. Multiple repositories or services alone do not require a spec: when one team can ship them together under one final contract, keep one coordinated plan.

Save plans to `docs/plans/YYYY-MM-DD-<slug>.md`. User or project instructions override this path.

## Before Writing

1. Inspect the real code, entrypoints, consumers, tests, and existing documents relevant to the task.
2. Separate established requirements from assumptions and unresolved decisions.
3. If an unresolved decision would materially change architecture, UX, data semantics, a public interface, or an irreversible outcome, ask one consolidated question before locking the plan.
4. Do not invoke brainstorming just to manufacture alternatives. Use it only when a real design decision remains unresolved.

## Default Delivery Model

Plan for the observed system and delivery team, not hypothetical future scale.
When internal producers and consumers can be changed and released together,
default to:

- one final contract and one coordinated release;
- one plan for the cross-repository business outcome;
- the smallest necessary deployment order or a brief maintenance window when
  an intermediate version combination is unsafe;
- one direct end-to-end check through the real consumer path.

Do not add high-concurrency architecture, distributed locks, generalized
retries, dual reads or writes, version matrices, staged rollout, canary gates,
or long-lived backward compatibility merely because several services are
involved. Locks and idempotency require concrete contending writers or
duplicate delivery. Compatibility and staged rollout require an independently
released or external consumer, or an unavoidable mixed-version window.
Recovery planning requires a genuinely irreversible data, permission, or
financial operation.

Low traffic does not disprove a correctness race. Duplicate payment callbacks,
two jobs writing the same order, or another traceable contention point still
deserve an explicit invariant. Without such a trigger, concurrency hardening
is speculative and stays out of the spec and plan.

## Required Plan Structure

```markdown
# [Feature Name] Implementation Plan

**Goal:** One sentence describing the observable outcome.

**Acceptance:** Concrete conditions that prove the goal is met.

**Architecture:** The chosen approach and the important boundaries, in a few sentences.

**Global constraints:** Exact cross-task requirements copied from the spec, project rules, or verified code contracts.

## File structure

- `path/to/file`: responsibility and why it changes

## Tasks

### Task N: [Reviewable deliverable]

**Files:** Files expected to be created or modified.

**Interfaces:** Exact signatures, payload shapes, names, or invariants consumed and produced by this task.

**Deliverable:** The observable behavior or artifact completed by the task.

**Implementation notes:** Only decisions and constraints that the implementer must not rediscover. Do not paste routine implementation bodies.

**Verification:** The smallest direct evidence that proves this task works. Do not add tests merely because the task changes behavior, fixes a bug, or carries business risk. Use strict TDD only when the user explicitly requests it or a project-local rule independently requires it.

**Commit boundary:** Required when this plan will use `subagent-driven-development`, because task review and recovery depend on isolated task commits. Otherwise include a commit only when the user requested commits or the execution workflow needs one.
```

## Task Boundaries

A task should be the smallest unit that:

- produces an independently observable result;
- can be reviewed without accepting all neighboring tasks;
- carries the setup, configuration, documentation, and verification needed by its result;
- names the interfaces later tasks rely on.

Split by deliverable and responsibility, not by technical layer. Follow the existing repository structure unless restructuring is itself an accepted requirement.

## What Not to Put in a Plan

- complete implementation functions or routine test bodies;
- mandatory red-green steps for work that does not warrant TDD;
- ceremonial rollout, migration, or governance steps without real production risk;
- speculative capacity or concurrency work without named contending call sites and deployment topology;
- backward-compatibility layers, dual reads or writes, staged rollout, canary gates, or rollback matrices when all internal callers can ship together;
- service dependency diagrams when a final contract, necessary deployment order, and consumer-path verification fully describe the change;
- placeholders such as `TBD`, `implement later`, or “add suitable tests”;
- copied context already recorded in a spec, ADR, issue, or existing plan;
- long prose that does not constrain implementation or verification.

Critical algorithms, data semantics, permission rules, or public contracts may include a compact pseudocode fragment or exact invariant when the implementation shape is itself part of the decision.

## Reviewing a Plan or Spec

Use this before handing off your own plan, and as the checklist when the user
asks you to review a plan or spec someone else wrote. Read it and respond
directly — a plan is not a code change, so do not dispatch a reviewer
subagent.

A plan cannot be proven by running it, and every downstream task inherits its
mistakes. So review only what is expensive to reverse once built and invisible
in a later diff:

1. **Premises.** Which load-bearing facts were verified against real data, and
   which are inference? A plan built on an unverified premise fails whole.
2. **Falsifiable acceptance.** Can you state the observation that decides
   success — and what failure would look like, such that the plan could be
   judged not worth keeping?
3. **Boundaries and contracts.** Ownership of data, who calls whom, the final
   interface shapes, and which external or independently released callers
   cannot change in the coordinated release.
4. **Data semantics.** Denominators, time windows, join keys, and exclusions
   pinned exactly. Wrong calibration produces wrong numbers that pass every
   test.
5. **State and migration.** What happens to existing data, whether one bounded
   migration reaches the correct final model, and whether legacy fields or
   fallbacks are removed. Require coexistence only when a named caller cannot
   ship together, and give that compatibility window an exit condition.
6. **Concurrency and failure handling.** Every proposed lock or idempotency
   mechanism names the real contending call sites, duplicate delivery source,
   and deployment shape. Every retry, timeout, fallback, or compensation names
   the observed failure boundary and why the mechanism changes the outcome.
   Service count and hypothetical future load are not evidence.
7. **Release coupling.** Treat a cross-repository change owned and released by
   one team as one deliverable unless ownership, timing, or rollback is truly
   independent. Record only the necessary deployment order and end-to-end
   consumer check; do not manufacture staged rollout.
8. **Permissions and PII.** Who can see what, tenant isolation, and which
   fields reach user-visible output.
9. **Irreversible points.** Which step cannot be undone — that is where commit
   boundaries and stronger verification belong, not spread evenly.
10. **Task independence.** Hidden ordering dependencies or two tasks editing
   the same file decide the execution route.
11. **Proportion.** A plan too heavy for its problem is a finding, in both
   directions.
12. **Implicit decisions.** Find the business choices the plan quietly made —
    a threshold, a default, a calibration — without surfacing them for the
    user.

Also confirm every acceptance condition maps to a task, task interfaces and
names are consistent, stale or speculative tasks are removed, verification
matches risk rather than habit, and the plan lives in the repository rather
than the conversation.

Out of scope: wording and formatting, implementation detail that belongs to
execution (naming, library choice, function decomposition), and demands that
the plan enumerate every edge case.

## Execution Routing

After saving the plan, return only a concise summary, its path, and the execution route:

- Use `subagent-driven-development` when tasks are independently implementable and reviewable in the current session and the plan authorizes task-level commits.
- Use `executing-plans` or direct main-agent execution when tasks lack commit boundaries, are tightly coupled, or delegation would add more coordination than value.

If the user already asked to implement the plan, begin the appropriate execution workflow without asking them to choose again.
