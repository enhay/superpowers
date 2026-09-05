---
name: subagent-driven-development
description: Use when executing a written plan and a bounded slice of the work benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
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

**In one shared checkout, a parallel worker's build, suite, dev server, or port
observes every other worker's half-finished state, so its result proves
nothing.** Parallel workers there edit and report only; you run the decisive
verification once after integration.

**Tell each worker what not to send back: no code bodies, no diff, no raw
output.** Its report is free-form text and nothing enforces a shape, so the
prohibition is the only part worth spending words on — returning everything is
the default, and it hands back the reading you delegated to avoid. Give it the
part of the plan it owns plus what it needs to finish cold, and keep briefs and
review notes off disk.

**Re-observe the outcome at its own layer; do not re-read the change.** A diff
shows what moved, not whether the accepted result holds, and it is the most
expensive thing you can pull into your own context. Read code only when code is
that layer — a permission boundary, a public contract's shape, the other callers
of a shared function — or when nothing runnable observes the outcome. A code
reviewer is the same trade: a separate decision, worth its cold read only for
risk no runnable check can see, spawned once over the assembled result, and it
owns that read rather than duplicating yours.
