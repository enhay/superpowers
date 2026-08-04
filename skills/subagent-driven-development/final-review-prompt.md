# Final Whole-Change Review Prompt Template

**Prefer this template.** Use a native review capability only when it accepts
custom review instructions, and then hand it the branch package as its diff and
the plan plus the Evidence Discipline section below as those instructions. The
plan alone is not enough: a default review rubric rewards thoroughness and will
return speculative findings the plan never asked about. Where the harness cannot
take custom instructions, use this template.

This is not [task-reviewer-prompt.md](task-reviewer-prompt.md). That template
opens by declaring itself a task-scoped gate that judges one task against one
brief; pointed at a whole branch it re-litigates every task in isolation and
reports cross-task work as missing. Use this one for the final pass and that one
for a task.

Start a worker that does not inherit this conversation's history, labelled "Final
review". This pass is worth the most capable model available.

The block below is the worker's message. It is content, not a call signature:

```
    You are reviewing a complete change against its intended outcome. The plan
    defines that outcome and its binding decisions; the assembled code and diff
    are the implementation evidence. Judge only what the whole change shows;
    later categories are conditional tests, not a checklist to complete.

    ## What Was Planned

    Read the plan: [PLAN_FILE] — its goal, acceptance conditions, architecture,
    and binding decisions are your reference. Internal path hints are not
    requirements unless the plan explains why they are binding.

    ## The Change

    **Change scope:** [CHANGE_SCOPE] — committed ranges or an uncommitted combined
    workspace change.
    **Diff file(s):** [DIFF_FILES] — one per repository or scope.

    Read the diff files once. They contain the available provenance, summary, and
    full diff with surrounding context. A change spanning repositories has one
    file per repository; read all of them before judging anything, because the
    contract that crosses them is exactly what this review exists to check. Do
    not re-run git commands.

    Your review is read-only. Do not mutate any working tree, index, HEAD or
    branch state.

    ## What to Judge

    1. **Acceptance coverage** — every acceptance condition in the plan, and
       where in the change it is met. A condition with no landing place is a
       finding even if every task passed.
    2. **Cross-task interaction** — a later task that undermined an earlier one,
       an interface that drifted between the task that published it and the task
       that consumed it, a constraint honoured in one task and violated in
       another.
    3. **Binding-decision compliance across the whole change** — check the plan's
       durable decisions against the assembled result, not against any single
       task.
    4. **Cross-repository consistency**, when the change spans repositories —
       payload shapes, field names, error codes and deploy order between
       producer and consumer. Name the deploy order the change requires and say
       whether the diff is safe in that order.
    5. **Material findings explicitly deferred during the run:**
       [DEFERRED_FINDINGS_OR_NONE]. Say for each whether the assembled change
       makes it consequential. Do not invent a roll-up from routine review notes.
    6. **What the change leaves behind** — a compatibility path with no exit,
       a migration that reaches a half-state, dead code the change orphaned,
       a guard removed whose trigger you can still reach.

    Do not report style, naming, decomposition or library choice. Do not report
    a defect confined to one task's internals unless the whole change makes it
    consequential — those were already gated.

    ## Evidence Discipline

    Every finding carries these two lines, with these labels, before anything
    else:

        Trigger: the real call site, reachable input, deploy order, or named
                 acceptance condition that reaches this
        Consequence: what it changes in the accepted outcome or a binding
                     decision

    "A caller could", "under load", "to be safe", and "a future change might"
    are not triggers. If you cannot fill both lines, the observation is not a
    finding at any severity — it goes to "Observations not raised": one line
    each, no severity, no fix instruction, no implied follow-up work. That
    section does not affect the verdict, and moving a failed-gate item into
    Minor defeats the gate.

    Inspect code outside the diff only
    to evaluate a concrete risk you can name — one focused check per named risk,
    and name both the risk and what you checked.

    Conversely: a lock, retry, fallback, defensive null guard or catch-all this
    change ADDED, whose trigger you cannot name, is a finding. So is a guard it
    REMOVED whose trigger you can still reach — say which call site reaches it.

    ## Output

    Write the full report to [REVIEW_FILE]: every line a verdict, a finding with
    file:line, or a check you ran. Group findings as Critical / Important /
    Minor, each opening with its `Trigger:` and `Consequence:` lines. End with
    an "Observations not raised" section: one line each, or `none`.

    Then return ONLY:
    - **Verdict:** Ready | Needs fixes
    - Counts by severity
    - One line per Critical/Important finding: `repo/file:line — what is wrong`
    - Any acceptance condition you could not confirm, one line each
    - The review file path

    Minor findings and "Observations not raised" stay in the file entirely — do
    not print them, summarize them, or count them here.

    The fix worker reads the file. Everything you print instead lives in the
    controller's context for the rest of the run.
```

**Placeholders:** `[PLAN_FILE]` the plan's path; `[CHANGE_SCOPE]` the honest
committed ranges or uncommitted workspace scope represented by the artifacts;
`[DIFF_FILES]` the matching paths, produced by the harness or by
`scripts/review-package -C REPO MERGE_BASE HEAD` when commits exist;
`[DEFERRED_FINDINGS_OR_NONE]` only material findings the controller intentionally
carried forward, or `none`;
`[REVIEW_FILE]` where the full report is written.
