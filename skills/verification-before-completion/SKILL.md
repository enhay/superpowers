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

For delegated work, inspect the actual diff and verification report before accepting the worker's status. For requirements, reconcile the implementation against the current plan or user request rather than treating passing tests as complete coverage.
