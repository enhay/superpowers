---
name: using-git-worktrees
description: Use when the user explicitly asks for a worktree or an approved implementation plan requires an isolated checkout. A worktree always means a standard git worktree directory.
---

# Using Git Worktrees

## Entry Condition

Use a worktree only when the user asks for one, project rules require isolation, or an approved plan explicitly places execution in one. Do not create a worktree merely because a task is multi-step.

## Process

1. Resolve the repository root, current branch, dirty state, existing linked worktrees, and intended base branch.
2. If already inside the intended worktree, reuse it. Never create a nested worktree.
3. Select the directory from explicit instructions or existing project convention. Otherwise use a project-local `.worktrees/<slug>` directory after verifying it is ignored.
4. Create a named branch and standard `git worktree` directory. Do not substitute `git switch` or `git checkout` in the current working tree.
5. Run only the setup and baseline checks needed for the planned work. Report pre-existing failures instead of silently treating them as new defects.
6. Preserve the worktree until the user explicitly asks to finish or remove it.

## Safety

- Unknown or dirty changes belong to the user; never clean or overwrite them.
- Do not create a worktree from an ambiguous base branch.
- Do not delete an existing worktree, branch, or directory to make room.
- Do not push merely because a new branch was created.
