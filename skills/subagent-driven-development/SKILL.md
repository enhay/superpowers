---
name: subagent-driven-development
description: Use when delegating implementation to subagents - executing a plan whose slices can be owned separately, or when the user asks for subagent execution.
---

# Subagent-Driven Development

Delegation is chosen and the orchestration shape is obvious. These go wrong
anyway.

**Delegation buys exactly one thing: reading that never enters your context.** It
repays only when that reading has not happened yet, will not be needed again by
you or by the next slice, and is far larger than what has to come back. Work
whose files and facts you can already name fails the first test — you did the
reading, and a worker would only pay for it a second time.

**Slice by module, not by plan step.** Delivery slices are cut for review and
rollback; a worker slice is cut so it can be finished from the code it owns. One
cutting across modules re-reads neighbours it does not own and sends the rest
back to you. Merge plan steps living in one module into one worker; never split a
module across two.

**Brief with context pointers, not with context.** A path, a commit, a spec
section, a scout's notes: the worker pulls what it needs at its own price, where
restating it in the brief spends yours. Where several workers need the same
ground, send one scout first to read it and write the notes the rest point at,
so that read is paid once.

**Acceptance is the one thing the brief states outright.** A worker starts cold
and stops when it believes it is done, so derive from the plan's need what done
means for its slice — **WHEN** a concrete trigger **THEN** an observable result,
and where that shows. When the slice is a judgment — rules, scoring, prompts,
analyses — a check on the samples at hand can be passed by fitting them, so
acceptance is how the requester will judge it: which real cases, against what;
and the worker states its approach before editing.

**Running workers at once breaks differently in one repo and across two.** In one
checkout it is a dirty read: any build, suite, dev server, or port sees the
others' half-finished state, so a green result proves nothing — worktrees dissolve
that and earn their cost only here, and without them either dispatch sequentially
or let workers edit and report while you verify once after integration. Across
repositories nothing is dirty, since ownership is disjoint and each side builds
alone; what diverges is the contract both workers are free to reshape. Bind it
before dispatch, or give one worker the contract and the other a consumer
forbidden to change it. Neither side's own green check says the pair works.

**Ask for what comes back, and bound it**: the files touched, the decisions made,
the check result, and what is still open, within a stated word budget. Nothing
enforces a report's shape, so naming the target and the budget is the whole
mechanism. Keep briefs and review notes off disk.

**Re-observe the outcome at its own layer; do not re-read the change.** A diff
shows what moved, not whether the accepted result holds, and it is the most
expensive thing you can pull into your own context. Read code only when code is
that layer — a permission boundary, a public contract's shape, the other callers
of a shared function — or when nothing runnable observes the outcome. Verify the
assembled result against the real consumer path, with the other side running. A
code reviewer is the same trade: worth its cold read only for risk no runnable
check can see, spawned once over the assembled result, and it owns that read
rather than duplicating yours.
