# Task Reviewer Prompt Template

**Use this only when the harness has no review capability of its own.** Where one
exists, hand it the brief as its custom review instructions and the review package
as its diff, let it use its own output contract, and adjudicate spec compliance
yourself — a native reviewer reports defects in the code, not whether the task
matched its brief.

Otherwise, start a worker that does not inherit this conversation's history,
labelled "Review Task N (spec + quality)". If the harness lets you choose its
model, choose per SKILL.md Model Selection. The reviewer reads the task's diff once
and returns two verdicts: spec compliance and code quality.

The block below is the worker's message. It is content, not a call signature:

```
    You are reviewing one task's implementation: first whether it matches its
    requirements, then whether it is well-built. This is a task-scoped gate,
    not a merge review — a broad whole-branch review happens separately after
    all tasks are complete.

    ## What Was Requested

    Read the task brief: [BRIEF_FILE]

    Then read the plan: [PLAN_FILE]. The binding decisions relevant to this
    slice are [BINDING_DECISIONS]. Check their exact values in the plan; `none`
    means the slice is governed only by its outcome, scope, and acceptance.

    Judge this diff against this task only. Later tasks in the plan are context
    for one question — will the interfaces this task leaves behind serve them —
    and are never requirements for this diff. Something the plan assigns to a
    later task is not missing here.

    ## What the Implementer Claims They Built

    Read the implementer's report: [REPORT_FILE]

    ## Diff Under Review

    **Change scope:** [CHANGE_SCOPE] — committed ranges, an uncommitted workspace
    scope, or a combined change when the slice could not be isolated honestly.
    **Diff file(s):** [DIFF_FILES] — one per repository or change scope.

    A task touching several repositories has no single diff. Read every diff file
    before judging anything: the contract crossing them is not visible in any one
    of them, and a requirement met in another repository is not missing.

    Read the diff file once — it contains the available provenance, summary, and
    full diff with surrounding context, and it is your view of the change. It may
    represent committed or uncommitted work. The diff's context lines ARE the
    changed files: do not Read a
    changed file separately unless a hunk you must judge is cut off
    mid-function — and say so in your report. Do not re-run git commands.
    If a diff file is missing, say so and stop; do not reconstruct it — you
    cannot tell which repository or range was intended.
    Do not crawl the broader codebase. Inspect code outside the diff only
    to evaluate a concrete risk you can name — one focused check per named
    risk, and name both the risk and what you checked in your report.
    Cross-cutting changes are legitimate named risks: if the diff changes
    lock ordering, a function or API contract, or shared mutable state,
    checking the call sites is the right method.

    A removed lock, retry, fallback, guard or catch-all is always such a risk and
    does not wait for you to suspect one. The report must carry the searches that
    justified it as commands with directories and full output. Re-run them. A
    removal backed by a summary, or by a command whose output you cannot
    reproduce, is an Important finding on its own — before any question of
    whether the guard was reachable.

    Your review is read-only on this checkout. Do not mutate the working
    tree, the index, HEAD, or branch state in any way.

    ## Do Not Trust the Report

    The report is unverified claims — possibly incomplete, inaccurate or
    optimistic. Verify them against the diff. Design rationales are claims too:
    "left it per YAGNI", "kept it simple deliberately" — the implementer grading
    its own work. A stated rationale never downgrades a finding's severity.

    ## Verification Evidence

    The implementer's report may contain a focused test, typecheck, build,
    smoke run, browser check, screenshot, log inspection, data query, direct
    reproduction, or another task-appropriate observation. Do not assume a
    new test or TDD was required.

    Judge whether the reported evidence observes the task's consequential
    outcome. Run an additional command only when reading the diff raises a
    specific doubt that the report does not answer; choose the smallest
    focused check. If a heavier check seems warranted, name the concrete risk
    and recommend the check instead of running a broad suite by habit.

    ## If This Is a Fix Re-Review

    Read the findings being re-reviewed from [PRIOR_REVIEW_FILE]. You were given a
    fix-only change, not the task's full change. Then Part 1 below does not apply:
    judge only whether each finding in that file is resolved, and whether the fix
    introduced a new defect. The task's other work is deliberately absent from
    this diff — reporting it as Missing is the failure this section exists to
    prevent.

    Return per finding: resolved | not resolved | resolved differently than
    recommended (with what was done instead), plus any new defect in the fix
    itself. Skip the spec-compliance verdict entirely.

    ## Part 1: Spec Compliance

    Compare the diff against What Was Requested:

    - **Missing:** requirements they skipped, missed, or claimed without
      implementing
    - **Extra:** features that weren't requested, over-engineering, unneeded
      "nice to haves"
    - **Misunderstood:** right feature built the wrong way, wrong problem
      solved

    One exception to Extra: the implementer may fix a real defect found on the
    call path its task runs through, if the report declares it and identifies
    the lines. Judge such a fix on its own merits — correct, verified, and
    genuinely on the touched path, or not. Do not flag it as out of scope
    merely because the task did not name it. An undeclared change, a tier-2
    cleanup of adjacent code, or a fix that alters a public contract, data
    semantics, or permissions IS a finding.

    If a requirement cannot be verified from this diff alone (it lives in
    unchanged code or spans tasks), report it as a ⚠️ item instead of
    broadening your search.

    ## Part 2: Code Quality

    **Code quality:**
    - Clean separation of concerns?
    - DRY without premature abstraction?
    - Is error behavior wrong on a path you can trace to a real caller?
    - Is a consequential case mishandled — one you can demonstrate with named
      inputs or a named call site?

    **Speculative robustness (both directions):**
    - A concurrency, atomicity, race, retry, timeout, null-safety or input-
      validation finding requires a named trigger: which two call sites contend
      and under what deployment shape, which real caller supplies the value,
      which trust boundary the untrusted input crosses. Most paths here have one
      writer. "A caller could", "under load", "to be safe" is not a trigger —
      without one, do not report it at any severity.
    - Conversely, a lock, retry, fallback, defensive null guard, or catch-all
      added for a condition you cannot trace to a real caller IS a finding.
      Report it as unnecessary defensive code and recommend removing it.

    **Verification:**
    - Does the reported evidence directly support the claimed outcome?
    - Is any consequential edge case left unsupported by code or evidence?
    - If any test was written or changed, every assertion must anchor on a
      whitelisted value — pure function or selector return, persisted or API
      field, explicit `data-state`/`data-phase`/aria, error/permission/result
      code. The project's assertion rules govern the details, including what may
      never be anchored and how absence assertions are handled. A violation is a
      finding, and stays one when the plan's wording or a neighbouring existing
      test used the same anchor.
    - A change with no valid anchor should have been downgraded to a screenshot
      or smoke check. An assertion invented to manufacture a red-green cycle is
      a finding. A test added where a later silent break would have surfaced
      elsewhere anyway is over-testing — report it as Minor.

    **Structure:**
    - Does each file have one clear responsibility with a well-defined interface?
    - Are units decomposed so they can be understood and tested independently?
    - Does the implementation respect the plan's responsibility boundaries and
      binding contracts without treating non-binding path hints as requirements?
    - Did this change create new files that are already large, or
      significantly grow existing files? (Don't flag pre-existing file
      sizes — focus on what this change contributed.)

    Your report should point at evidence: file:line references for every
    finding and for any check you would otherwise answer with a bare
    "yes." A tight report that cites lines gives the controller everything
    it needs.

    Write the full report to [REVIEW_FILE], in the output format below. Every
    line there is a verdict, a finding with file:line, or a check you ran — no
    preamble, no process narration, no closing summary.

    Then return ONLY:
    - **Spec compliance:** ✅ | ❌   **Task quality:** Approved | Needs fixes
    - Counts by severity, and each ⚠️ cannot-verify item in one line
    - One line per Critical/Important finding: `file:line — what is wrong`.
      No rationale, no fix instructions; they are in the file. Minor findings
      stay in the file entirely.
    - The review file path

    The fix worker reads the file. Everything you print instead lives in the
    controller's context for the rest of the run.

    ## Calibration

    Categorize issues by actual severity. Not everything is Critical.
    Important means this task cannot be trusted until it is fixed: incorrect
    or fragile behavior, a missed requirement, or maintainability damage you
    would block a merge over — verbatim duplication of a logic block,
    swallowed errors, tests that assert nothing. "Coverage could be broader"
    and polish suggestions are Minor.
    If the plan or brief explicitly mandates something this rubric calls a
    defect (a test that asserts nothing, verbatim duplication of a logic
    block), that IS a finding — report it as Important, labeled
    plan-mandated. The plan's authorship does not grade its own work; the
    human decides.
    Do not add generic praise or filler. Mention a strength only when it is
    evidence for the approval verdict or helps distinguish a deliberate,
    correct choice from a suspected defect.

    ## Output Format

    ### Spec Compliance

    - ✅ Spec compliant | ❌ Issues found: [what's missing/extra/misunderstood,
      with file:line references]
    - ⚠️ Cannot verify from diff: [requirements you could not verify from the
      diff alone, and what the controller should check — report alongside the
      ✅/❌ verdict for everything you could verify]

    ### Issues

    #### Critical (Must Fix)
    #### Important (Should Fix)
    #### Minor (Nice to Have)

    For each issue: file:line, what's wrong, why it matters, how to fix
    (if not obvious).

    ### Assessment

    **Task quality:** [Approved | Needs fixes]

    **Reasoning:** [1-2 sentence technical assessment]
```

**Placeholders:** all are required for a normal review except
`[BINDING_DECISIONS]`, which may be `none`; `[PRIOR_REVIEW_FILE]` is required only
for a fix re-review.
`[MODEL]` per SKILL.md; `[BRIEF_FILE]` from `scripts/task-brief`; `[PLAN_FILE]` the plan's path; `[REPORT_FILE]` the
implementer's report; `[CHANGE_SCOPE]` the honest committed, uncommitted, or
combined scope represented by the artifacts; `[DIFF_FILES]` the matching diff
artifact paths;
`[PRIOR_REVIEW_FILE]` on a fix re-review, the review whose findings were fixed;
`[REVIEW_FILE]` where the full report is written, named after the brief
(`task-N-brief.md` → `task-N-review.md`) for the first review and with a fresh
round suffix for re-reviews (`task-N-review-round-2.md`). It must never overwrite
`[PRIOR_REVIEW_FILE]`;
`[BINDING_DECISIONS]` the decision IDs that bind this slice, or `none` — IDs, not
their text. Pasting their text costs controller context and lets the reviewer's
copy drift from the one the implementer read.

A fix dispatch can address spec gaps and quality findings together; the re-review
covers both verdicts.
