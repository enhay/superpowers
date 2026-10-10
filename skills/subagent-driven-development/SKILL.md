---
name: subagent-driven-development
description: Use when delegating implementation to subagents - executing a plan whose slices can be owned separately, or when the user asks for subagent execution.
---

# Subagent-Driven Development

Delegation pays for reading that never has to enter your context. Use it to keep
your context small, not to redo reading you have already done.

## Guidance

- **When.** Delegate a slice only when its reading has not happened yet, will not
  be needed again by you or the next slice, and is far larger than what comes
  back. If you can already name the files and facts, do the work yourself.
- **Slicing.** Cut worker slices by module, so each finishes from the code it
  owns. Delivery slices are cut for review and rollback; merge the steps that live
  in one module into one worker.
- **Brief.** Point to context — paths, commits, spec sections, a scout's notes —
  instead of restating it. When several workers need the same ground, send one
  scout first and point the rest at its notes.
- **Tier.** Before dispatch, weigh whether the slice needs the current tier; a
  new model starts cache-cold. A model the user names wins; the runtime's global
  rules map tiers to models, else the worker inherits.
- **Acceptance.** A worker starts cold and stops when it believes it is done, so
  state what done means: WHEN a concrete trigger THEN an observable result, and
  where it shows. Point to the Need the slice serves, so the check reads as
  evidence of it rather than the target. For judgment work — rules, scoring,
  prompts, analyses — whatever the worker sees can be fitted: give some real cases
  and their kinds, keep others back for your own verification, and have the
  worker state its approach before editing.
- **Concurrency.** In one checkout, parallel workers see each other's half-done
  state, so their green checks prove nothing. Across repositories, the risk is
  the shared contract: bind it before dispatch, or make one side a consumer that
  may not change it.
- **Verification.** Re-observe the outcome at its own layer instead of reading the
  diff. Read code only when code is that layer — permissions, a public contract's
  shape, other callers of a shared function — or when nothing runnable observes
  it. A code reviewer earns its cold read only for risk no runnable check can
  see, spawned once over the assembled result.

## Constraints

1. One module, one worker; never split a module across workers.
2. Every brief states acceptance and the return — files touched, decisions made,
   check result, what is open — within a word budget. Briefs and review notes
   stay off disk.
3. Parallel workers in one checkout use worktrees; otherwise run them
   sequentially, or let them only edit and verify once after integration.
4. A worker never edits the acceptance check, its fixtures, or existing test
   expectations; a check it believes wrong is reported, not changed.
5. Accept the assembled result by observing it on the real consumer path, with
   the other side running — never by a worker's report or green check alone.
