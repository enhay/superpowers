---
name: systematic-debugging
description: Trace an unexplained defect to a verified root cause after literal search and local call-chain inspection fail to explain it. Use for inconsistent reproduction, multi-component failures, or a focused fix attempt that already failed.
---

# Systematic Debugging

Start here only after direct source inspection cannot explain the symptom.

Reproduce it and capture the complete output. Trace the failing value across each
component boundary — against the nearest working path and recent relevant changes
— recording where it is still correct and where it first diverges. State one
root-cause hypothesis tied to that evidence and test it with the smallest action
that can falsify it.

Do not propose a fix until the failing boundary and causal mechanism are supported
by evidence. If the evidence rejects the hypothesis, replace it rather than
stacking another speculative fix.

For a diagnosis-only request, stop at the verified cause, impact, and evidence.
When implementation is authorized, fix the source with one focused change and
re-observe the original symptom.
