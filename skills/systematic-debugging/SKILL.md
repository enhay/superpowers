---
name: systematic-debugging
description: Use when a defect remains unexplained after a literal search and local call-chain inspection, reproduces inconsistently, spans multiple components, or a focused fix attempt has failed.
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

Fix the source of the problem with one focused change. Decide whether to add a test through `right-sizing-tests`; debugging complexity alone does not require TDD. A smoke run, existing check, log inspection, or direct reproduction may be sufficient.

Verify the original symptom and report the evidence used.
