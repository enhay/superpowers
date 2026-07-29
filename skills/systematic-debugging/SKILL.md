---
name: systematic-debugging
description: Trace an unexplained defect to a verified root cause before proposing a fix. Use once a literal search and local call-chain inspection have failed to explain the behavior — including when it reproduces inconsistently, spans multiple components, or a focused fix attempt has already failed.
---

# Systematic Debugging

## Entry condition

Do not start here for a local, directly searchable bug. First inspect the literal source and nearby call chain on the main line. Enter this workflow only when that direct inspection cannot explain the behavior.

## Investigation

1. Reproduce the symptom and read the complete error or trace.
2. Check recent relevant changes and compare a nearby working path.
3. Trace inputs and outputs across each involved component boundary.
4. State one root-cause hypothesis supported by the evidence.
5. Test that hypothesis with the smallest diagnostic action.

Do not propose a fix before the evidence identifies the failing boundary.

## Implementation

Fix the source of the problem with one focused change. Debugging complexity alone does not require a new test or TDD. Prefer the cheapest direct evidence that observes the consequential outcome: the original reproduction, an existing focused check, a smoke run, log inspection, or a data query. Add a regression test only when it protects an enduring observable contract; use strict TDD only when the user explicitly requests it or a project-local rule independently requires it.

Verify the original symptom and report the evidence used.
