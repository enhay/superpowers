---
name: systematic-debugging
description: Trace an unexplained defect to a verified root cause after literal search and local call-chain inspection fail to explain it. Use for inconsistent reproduction, multi-component failures, or a focused fix attempt that already failed.
---

# Systematic Debugging

Start here only after direct source inspection cannot explain the symptom.

1. Reproduce the symptom and capture the complete error, trace, or incorrect
   output.
2. Check recent relevant changes and compare the nearest working path.
3. Trace the failing value or state across each component boundary, recording
   where it is still correct and where it first diverges.
4. State one root-cause hypothesis tied to that evidence.
5. Test it with the smallest diagnostic action that can falsify it.

Do not propose a fix until the failing boundary and causal mechanism are
supported by evidence. If the evidence rejects the hypothesis, replace it; do
not stack speculative fixes.

For a diagnosis-only request, stop at the verified cause, impact, and evidence.
When implementation is authorized, fix the source with one focused change and
re-observe the original symptom. Add a regression test only when the defect could
return silently without another project signal; otherwise use the cheapest direct
evidence that proves the outcome.
