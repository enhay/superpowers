---
name: executing-plans
description: Use when executing a written implementation plan whose tasks are tightly coupled or better handled by the main agent than by fresh workers.
---

# Executing Plans

Execute a durable plan on the main line while keeping it aligned with current code facts.

Use `subagent-driven-development` instead when tasks are independently implementable and reviewable. Do not delegate merely because workers are available.

## Load and Reconcile

1. Read the plan and any referenced spec.
2. Inspect the current code and working-tree state relevant to the first task.
3. Treat the user-owned goal and acceptance criteria as fixed. Treat implementation notes, file lists, task order, and verification commands as revisable when current evidence disproves them.
4. Ask one consolidated question only when a conflict would materially change architecture, UX, data semantics, permissions, a public contract, or an irreversible outcome.

Do not pause for approval over reversible implementation details that can be resolved from code and project conventions.

## Execute

For each task:

1. Mark it in progress.
2. Implement the task's deliverable and preserve its interfaces and binding constraints.
3. Run the smallest direct verification that proves the deliverable.
4. Update the plan with corrected facts, completed work, and remaining tasks; remove stale todo items and obsolete steps.
5. Mark the task complete only when its acceptance evidence is present.

Continue through the plan without routine check-ins. Stop only for a material unresolved decision, missing authority, unsafe or irreversible action, overlapping user changes, or a blocker that remains after focused investigation.

## Git and Isolation

- Before the first edit, inspect the working tree. If it holds uncommitted changes you did not make, ask the user how to proceed before editing. Never stash, revert, check out over, or commit them to clear the way.
- Work in the current checkout unless the user, project rules, or approved plan explicitly requires a standard git worktree.
- Do not create commits unless the user requested them or the approved plan defines commit boundaries.
- Never push, merge, clean a worktree, or remove a branch without explicit authorization.
- Preserve unknown or unrelated changes as user-owned.

## Completion

After all tasks are complete, reconcile the final implementation against the plan's goal and acceptance criteria, report the verification evidence and remaining repository state, and leave the plan as an accurate recovery document.

Use `finishing-a-development-branch` only when the user explicitly asks to finish, merge, integrate, create a PR, or clean up the branch.
