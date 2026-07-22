---
name: verification-before-completion
description: Use before claiming a requested change is complete or correct when fresh observable evidence is needed to support that claim.
---

# Verification Before Completion

## Principle

Completion claims require fresh evidence proportional to the claim and risk. Evidence may be a focused test, typecheck, build, smoke run, browser check, screenshot, log inspection, data query, or direct reproduction.

## Process

1. Name the concrete outcome being claimed.
2. Select the smallest command or observation that directly proves that outcome under project rules.
3. Run it fresh and read the exit status and relevant output.
4. If it fails or proves only part of the claim, report the actual state and remaining gap.
5. Claim completion only to the extent supported by the evidence.

Do not substitute confidence, an earlier run, a worker report, or an unrelated green check for direct evidence. Do not require a full test suite, new regression test, or TDD cycle when a lighter observation proves the requested outcome.

## Traps

- **Verify through the consumer, not the write.** The table you wrote is not the view the user reads. For a data fix or backfill, confirm each affected record through the real consuming path — the API response or the UI — because a stale placeholder row or a different read path can leave the outcome unchanged while your write looks correct.
- **Quantify before asserting a negative.** Before claiming a feature never worked, a field is always empty, a call always fails, or something is high-frequency, query the real data. A code-level root cause can be internally consistent and still contradicted by production. Distinguish "empty because it failed" from "empty because there was never data".
- **Count events, not lines.** Deduplicate failures by event or request id. Raw `grep` line counts inflate several times over through multi-line stack traces and duplicate handlers.
- **Treat a worker or agent conclusion as a hypothesis**, including a confident one with file and line citations. Verify it against the artifact or the data before adopting it.
- **A UI change matching a mockup needs a visual check.** String or structural smoke tests pass while the result looks wrong; compare a screenshot.

For delegated work, inspect the actual diff and verification report before accepting the worker's status. For requirements, reconcile the implementation against the current plan or user request rather than treating passing tests as complete coverage.
