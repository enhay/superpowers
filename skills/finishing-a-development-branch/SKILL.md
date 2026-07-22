---
name: finishing-a-development-branch
description: Use only when the user explicitly says to finish, wrap up, integrate, merge, or otherwise complete a development branch.
---

# Finishing a Development Branch

## Entry Condition

Do not trigger merely because implementation appears complete. Use this workflow only after the user explicitly asks to finish, wrap up, merge, integrate, create a PR, or clean up the branch.

## Process

1. Inspect the current branch, worktree provenance, dirty state, commits, base branch, and relevant remote state.
2. Run the verification that supports the requested integration. Use the plan's verification strategy and project rules; do not invent a full-suite gate without cause.
3. If the worktree is dirty, the branch conflicts, verification fails, or unrelated changes overlap, stop and report the exact state.
4. Execute only the operation the user requested:
   - local merge: merge locally and verify the merged result;
   - PR: push and create a PR only when explicitly requested;
   - keep: preserve the branch and worktree;
   - cleanup: remove only worktrees and branches this workflow created and only after successful integration or explicit confirmation.

Never present a destructive discard option proactively. Deleting commits, branches, or worktrees with unmerged work requires explicit target resolution and confirmation.

## Boundaries

- “收尾” permits local integration, not push.
- Never pull, push, force-push, delete a branch, or remove a worktree unless the requested workflow requires it.
- Never clean harness-owned or user-created worktrees merely because the branch is complete.
- Never hide a failed verification behind a completion claim.
