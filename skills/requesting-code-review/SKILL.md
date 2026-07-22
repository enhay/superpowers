---
name: requesting-code-review
description: Use when dispatching a reviewer at a code change (diff or commit range) because the user explicitly asked for code review, an approved plan defines a review boundary, or subagent-driven development requires task or final review. Not for reviewing a plan, spec, document, or other prose artifact, and not for ordinary task completion.
---

# Requesting Code Review

Use an independent, read-only reviewer when review is part of the accepted workflow. Ordinary small changes use direct inspection and proportional verification instead of automatically dispatching another agent.

## Entry Condition

Request review only when at least one condition is true:

- the user explicitly asks for review;
- an approved plan names a review boundary;
- `subagent-driven-development` requires its task-scoped or final review;
- a requested merge or integration workflow requires an independent readiness check.

Do not trigger merely because implementation is complete, a change is called a feature or bugfix, or a reviewer is available.

The object of review is always a code change — a diff file, commit range, or working-tree diff. A request to review a plan, spec, proposal, design document, report, or any other prose artifact is not a code review, even though it uses the word "review". Read and critique it directly instead; plan quality criteria live in `writing-plans`. Do not dispatch a reviewer subagent when there is no diff to hand it.

## Prepare the Review

Provide the reviewer with:

- the exact requirement, plan task, or acceptance criteria;
- the change under review as a diff file, commit range, or current working-tree diff;
- any binding project constraints;
- the verification evidence already collected.

Do not create a commit solely to manufacture a review range. Do not paste session history or implementation reasoning when the requirements and diff are sufficient.

## Dispatch

Use the read-only template at [code-reviewer.md](code-reviewer.md). Scope the reviewer to the supplied change and named risks. Broaden into unchanged code only when a concrete integration, contract, security, or data risk requires it.

## Act on Findings

- Verify every finding against the actual code and requirements.
- Fix Critical findings before accepting the work.
- Fix Important findings that make the requested outcome incorrect, incomplete, unsafe, or materially unmaintainable.
- Treat Minor findings as advisory unless the user or plan includes them.
- Push back with evidence when a finding is incorrect or expands scope.
- Re-review only the amended area unless the fix changes a broader contract.

Review does not authorize new features, unrelated refactors, extra tests, migrations, compatibility work, documentation, commits, or external actions that were not already in scope.

## Workflow Integration

- **Subagent-driven development:** retain task-scoped review after each task and one broad final review.
- **Executing plans:** review only at plan-defined boundaries or when the user explicitly asks.
- **Ad-hoc work:** review only on explicit request; completion alone is not a trigger.
- **Finishing a branch:** use review only when the requested finish or integration workflow requires it.
