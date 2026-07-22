---
name: receiving-code-review
description: Use when receiving code review feedback before implementing it, especially when findings are unclear, technically questionable, or may expand scope.
---

# Receiving Code Review

Treat review findings as technical claims to verify, not commands to accept or social prompts to perform.

## Process

1. Read the complete feedback and map each finding to the cited code and requirement.
2. Verify whether the finding is correct for this codebase, supported versions, and accepted scope.
3. Separate independent findings from findings that share an architectural, UX, data, permission, or public-contract decision.
4. Implement clear, correct, in-scope findings. Batch only the material ambiguities that require user direction.
5. Use the smallest direct verification that proves each amended outcome.
6. Reconcile the final diff against the original request so review work does not become scope creep.

Do not stop all progress because one independent item is unclear. Continue with unrelated findings when doing so cannot prejudice the unresolved decision.

## Triage First

External reviewers — a stronger model at high reasoning effort especially — over-cover edge cases. Breadth is not evidence of importance. Sort every finding before implementing any of it:

- **Accept:** correctness bugs, divergence between the implementation and its stated design, structural design faults, and anything that makes the requested outcome fail.
- **Reject:** edge-case over-coverage, style and wording, low-ROI defensive suggestions, and "theoretically possible but does not occur here".
- **Demand a named trigger** for any concurrency, atomicity, race, retry, timeout, null-safety, or input-validation finding: which two call sites contend under what deployment shape, which real caller supplies the value, or which trust boundary the untrusted input crosses. Without one it is rejected — implementing it adds a lock, retry, or guard for a condition that cannot occur, and defensive code accumulates because rejecting costs more than complying.

Read the code or the data for each finding before deciding. Say why each rejected finding was rejected; a silent drop reads as an oversight.

## Push Back When

- the reviewer did not inspect the relevant producer, consumer, registration, or compatibility path;
- the suggestion contradicts verified code facts or the user's accepted decision;
- it adds speculative flexibility, unused infrastructure, unrelated cleanup, or a new public behavior;
- it would break supported versions, data semantics, permissions, or existing callers;
- severity is inflated beyond the observable consequence.

State the evidence and the consequence directly. If a finding depends on a material product or architecture choice that cannot be resolved from the repository, ask one consolidated question.

## Verification and Scope

Review feedback does not independently require TDD, a new regression test, a full suite, a refactor, or a migration. Match verification to the durable observable behavior and project rules.

When changing or deleting code because of review feedback, inspect literal references and wiring first. Remove only code made obsolete by the accepted fix unless broader cleanup was explicitly requested.

## External Review Threads

When the user asks to reply to an inline GitHub review comment, reply in that comment thread rather than creating an unrelated top-level comment. Do not post or mutate external systems without explicit authorization.
