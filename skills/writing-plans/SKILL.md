---
name: writing-plans
description: Use when a medium or larger task needs a durable implementation plan before code changes, or when the user explicitly asks for a plan. Skip trivial and small tasks that can be completed directly.
---

# Writing Plans

## Purpose

Turn verified requirements and current code facts into a durable implementation plan. Keep the plan at contract level so a capable main agent or worker can implement it without copying speculative code from the planning stage.

Do not use this skill merely because a task has several steps. Trivial and small work stays on the direct `inspect -> implement -> verify` path.

## Artifact Escalation

Choose the smallest durable artifact that fits the work:

- **Commit-level change:** The change is local and its intent can be explained in a commit message. Do not create a plan or spec.
- **One implementation plan:** The requirements are established, but the work spans multiple reviewable tasks. Write one plan.
- **Spec then plans:** Architecture, UX, data semantics, public interfaces, or multiple independent subsystems still need durable decisions. Write or update a spec first, then create one or more plans.

Save plans to `docs/plans/YYYY-MM-DD-<slug>.md`. User or project instructions override this path.

## Before Writing

1. Inspect the real code, entrypoints, consumers, tests, and existing documents relevant to the task.
2. Separate established requirements from assumptions and unresolved decisions.
3. If an unresolved decision would materially change architecture, UX, data semantics, a public interface, or an irreversible outcome, ask one consolidated question before locking the plan.
4. Do not invoke brainstorming just to manufacture alternatives. Use it only when a real design decision remains unresolved.

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

**Verification:** The smallest evidence that proves this task works. Testing intensity follows project rules and `right-sizing-tests`; TDD is not automatic.

**Commit boundary:** Suggested task-level commit when plan execution includes commits.
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
- placeholders such as `TBD`, `implement later`, or “add suitable tests”;
- copied context already recorded in a spec, ADR, issue, or existing plan;
- long prose that does not constrain implementation or verification.

Critical algorithms, data semantics, permission rules, or public contracts may include a compact pseudocode fragment or exact invariant when the implementation shape is itself part of the decision.

## Self-Review

Before handing off the plan:

1. Map every acceptance condition to at least one task.
2. Check task interfaces and names for consistency.
3. Remove stale or speculative tasks.
4. Confirm verification matches risk rather than habit.
5. Confirm the plan is stored in the repository instead of being dumped into the conversation.

## Execution Routing

After saving the plan, return only a concise summary, its path, and the execution route:

- Use `subagent-driven-development` when tasks are independently implementable and reviewable in the current session.
- Use `executing-plans` or direct main-agent execution when tasks are tightly coupled or delegation would add more coordination than value.

If the user already asked to implement the plan, begin the appropriate execution workflow without asking them to choose again.
