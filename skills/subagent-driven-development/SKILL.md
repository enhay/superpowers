---
name: subagent-driven-development
description: Use when executing a written plan and a bounded slice of the work benefits from fresh worker context, or when the user explicitly requests subagent execution. Do not use for trivial work or work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Delegation is chosen and the orchestration shape is obvious. These four go wrong
anyway.

**Slice by module, not by plan step.** Delivery slices are cut for review and
rollback; a worker slice is cut so it can be finished from the code it owns. One
that cuts across modules re-reads neighbours it does not own and sends the rest
back to you. Merge plan steps living in one module into one worker, never split a
module across two — and check the floor first: if writing the brief would already
state the change, make the change yourself.

**In one shared checkout, a parallel worker's build, suite, dev server, or port
observes every other worker's half-finished state, so its result proves
nothing.** Parallel workers there edit and report only; you run the decisive
verification once after integration.

**A worker returns files touched, decisions made, its check result, and open
questions — not code, not a diff, not raw output**, which hand back the reading
you delegated to avoid. Give it the part of the plan it owns plus every fact it
needs to finish cold, not the whole plan, and no brief or review file on disk.

**Re-observe the outcome at its own layer; do not re-read the change.** A diff
shows what moved, not whether the accepted result holds, and it is the most
expensive thing you can pull into your own context. Read code only when code is
that layer — a permission boundary, a public contract's shape, the other callers
of a shared function — or when nothing runnable observes the outcome. A code
reviewer is the same trade: a separate decision, worth its cold read only for
risk no runnable check can see, spawned once over the assembled result, and it
owns that read rather than duplicating yours.
