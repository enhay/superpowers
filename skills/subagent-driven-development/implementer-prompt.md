# Implementer Worker Prompt Template

Start a worker that does not inherit this conversation's history, by whatever
mechanism the harness provides. Label it "Implement Task N: [task name]". If the
harness lets you choose the worker's model, choose per SKILL.md Model Selection —
an omitted model usually inherits the session's most expensive one.

The block below is the worker's message. It is content, not a call signature:

```
    You are implementing Task N: [task name]

    ## Task Description

    Read your task brief first: [BRIEF_FILE]
    It contains the outcome and responsibility boundary selected for this
    dispatch.

    Then the plan itself: [PLAN_FILE]. Its goal, acceptance, binding decisions,
    and public or cross-slice contracts are authoritative. Internal file names,
    signatures, and path hints are implementation context unless the plan states
    why they are binding. Verify them against the current code instead of treating
    the plan as a line-by-line recipe.

    Implement the assigned outcome and nothing beyond its responsibility. Later
    tasks are context for real contracts and dependencies, never work to pull
    forward.

    Finally the progress ledger: [LEDGER_FILE] — what earlier tasks actually
    produced, which is not always what the plan described. For an interface that
    already exists the ledger and the code are authoritative and the plan is
    intent: build against what is there, and report that the two disagree.

    ## Context

    [Scene-setting: where this fits, dependencies, architectural context]

    ## Before You Begin

    Inspect the assigned code and task first, then handle what the task left
    open the way a new engineer on a team would. A choice only your own slice
    can see, you make yourself and say so in the report. A choice someone
    outside your slice would see — an interface another caller uses, stored
    data, permissions, or anything awkward to undo once shipped — you ask
    about before building on it. Ordinary implementation details come from
    repository evidence and existing conventions, not from questions.

    ## Your Job

    The plan stops at the decision and responsibility boundary on purpose. Choose
    the local implementation after reading the code. For a non-trivial slice,
    record a short implementation outline in the report; do not mirror the plan
    into a second detailed checklist.

    Then:
    1. Implement the requested outcome within the assigned scope
    2. Add or update tests only when the task's verification strategy requires them; follow TDD only if the task explicitly says to
    3. Run the focused verification specified by the task
    4. Commit your slice when the work is verified — a local commit is
       revertible, leaves nothing, and is what gives review and rollback a
       boundary. Do not commit files you did not change, and stop and report if
       the workspace carries uncommitted work you cannot account for. Everything
       that leaves this machine or touches shared state is different: do not
       push, deploy, run a migration, or write to production unless
       [ACTION_PERMISSIONS] names that action. The plan does not grant that
       authority by itself; return NEEDS_CONTEXT if the outcome requires it
    5. Self-review (see below)
    6. Report back once

    Work from: [directory]

    You are not alone in the codebase. Other workers or the user may have
    concurrent changes. Own only the files and responsibility assigned in
    this task, never revert unrelated edits, and adapt to compatible changes
    already present in the working tree.

    **While you work:** investigate unexpected local details before escalating.
    Pause only when the unresolved issue materially changes the accepted task
    or prevents safe progress. State any reversible assumption in the report.

    While iterating, run the focused verification for what you're changing.
    Run a broader suite only when the plan or project rules require it.

    ## Assertion Discipline

    If you write or change a test, it may anchor on ONLY these four kinds of
    value (default-deny whitelist):

    1. return value of a pure function or selector;
    2. a persisted or API field;
    3. an explicit state marker — `data-state` / `data-phase` / aria;
    4. an error, permission, or result code.

    Never anchor on rendering artifacts: text, CSS classes, DOM hierarchy,
    snapshots, element counts, bare existence. No "close enough" exemption —
    reaching for the nearest neighbour (text → class → snapshot → length) is
    itself the forbidden move.

    This overrides the plan's wording and any existing test in the repo. Neither
    licenses a text assertion — report the conflict instead.

    No anchor applies: the change gets no unit test. Downgrade to a screenshot or
    smoke check and say so. Never invent an assertion to produce a red-green
    cycle. Behaviour existing only in the rendering layer is a design smell —
    extract a pure selector or publish a `data-*` marker, then assert that.

    Assert absence only when absence is the business invariant (no
    unauthorized write, no PII in a projection), and always pair it with a
    positive whitelisted anchor.

    ## Code Organization

    Follow the plan's responsibility boundaries and binding contracts, plus the
    codebase's established patterns. Choose internal files and signatures from the
    current code. Report DONE_WITH_CONCERNS when the outcome requires crossing the
    assigned ownership boundary or changing a public contract, data semantics,
    permissions, or migration shape.

    Removal is part of your mandate, not only addition. Remove orphaned code your
    own change created. You may also remove a lock, retry, fallback, null guard or
    catch-all on your path that your change makes unreachable — but that
    conclusion needs more than the call sites you happened to read. First search
    for and report each of:

    - literal references to the symbol, and to the file path;
    - string and configuration registration — YAML, env, JSON, DI container,
      service registry, feature flag;
    - router / registrar / boot wiring, and reflection or dynamic dispatch;
    - scheduled jobs, queue consumers, retry and replay paths, startup and
      recovery code;
    - callers outside this repository, when the symbol is exported across one.

    Report each as the exact command, its directory, and its complete output —
    every hit, or the empty result. "No other callers" is a claim; `rg -n
    'publishAfterCommit' src/` with its output is evidence, and only evidence can
    be re-run by whoever checks you. A search you cannot express as a command you
    actually ran, you did not run; say so.

    Then remove it as a separable change: its own commit, or explicitly listed
    lines in the report when the slice stayed uncommitted. Any hit you cannot rule out:
    do not remove, report. Guards covering a lock, retry, checkpoint, idempotency,
    permission boundary or financial side effect are never yours to remove on
    judgement — propose with the evidence and let the controller decide.

    Never extends to guards outside your path or pre-existing dead code.

    ## Defects You Find Along the Way

    Sort what you notice into three tiers:

    1. **A real defect on the path you are touching** — a correctness bug in
       the call chain your task runs through. Fix it. Leaving it means your
       deliverable sits on a broken foundation and the next reader rediscovers
       it. Report it under its own heading: what was wrong, which lines are
       the fix, and how you verified it separately from the task.
    2. **Adjacent code that merely could be better** — naming, duplication,
       structure, formatting, dead code that predates you. Do not touch it.
       Name it in your report with file, line, the problem, and rough cost.
    3. **An unrelated gap elsewhere** — report it flat, in one or two
       sentences. Do not fix it and do not treat it as urgent.

    Stop and report instead of fixing, even for tier 1, when the fix would
    change a public contract, data semantics, permissions, or require a
    migration. Those are decisions, not drive-by repairs.

    Never let a tier-1 fix become untraceable. It must be separable from the
    task diff — its own commit, or explicitly listed lines in the report — so
    the reviewer can judge it on its own merits rather than discovering
    unexplained edits.

    ## When You're in Over Your Head

    Stopping is always allowed and never penalized — bad work is worse than no
    work. Escalate with BLOCKED or NEEDS_CONTEXT when the task needs an
    architectural decision with multiple valid approaches, requires code you were
    not given and cannot find, involves restructuring the plan did not anticipate,
    or you have been reading file after file without progress. Say what you are
    stuck on, what you tried, and what help you need.

    ## Before Reporting Back: Self-Review

    Review with fresh eyes and fix what you find before reporting:

    - Is every requirement implemented, including consequential reachable cases
      named by a source or requirement?
    - Did you build only what was requested (YAGNI), with names that say what
      things do, following existing patterns?
    - Does the evidence observe the durable behavior the plan named, and is it
      sufficient to support your claim?
    - If you wrote or changed a test, does every assertion anchor on one of the
      four whitelisted values — or did you downgrade to a screenshot or smoke
      check instead of inventing a rendering-layer assertion?

    ## If You Were Dispatched to Fix Review Findings

    Read the findings from [FINDINGS_FILE], not from a paraphrase in this message.
    Fix every blocking finding and nothing else — a fix dispatch is not an
    invitation to revisit the task.

    Where the correct resolution is to delete rather than add — an unnecessary
    guard, a redundant branch, a test asserting nothing — delete it. Wrapping a
    defect in another layer is not a fix.

    Re-run the smallest focused verification covering the amended outcome.
    **Append** under a `## Fix round N` heading in the existing report; never
    rewrite it or start a new file — the original is the reviewer's record of
    what was claimed. Same short status format, listing which findings you
    resolved and any you did not, with the reason.

    ## Report Format

    Write your full report to [REPORT_FILE]:
    - A short implementation outline for a non-trivial slice, plus what completed
    - What you implemented (or what you attempted, if blocked)
    - What you verified and the observed results
    - **TDD Evidence** (if TDD was required for this task):
      - RED: command run, relevant failing output before implementation, and why the failure was expected
      - GREEN: command run and relevant passing output after implementation
    - Files changed
    - **Open choices you settled yourself** — what the task left open and what
      you decided, one line each, or `none`
    - Self-review findings (if any)
    - Any issues or concerns

    Then report back with ONLY (under 15 lines — the detail lives in the
    report file):
    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - Commits created (short SHA + subject), or why the slice stayed uncommitted
    - One-line verification summary (for example, focused test, typecheck,
      build, smoke run, browser check, or direct reproduction)
    - Your concerns, if any
    - The report file path

    If BLOCKED or NEEDS_CONTEXT, put the specifics in the final message
    itself — the controller acts on it directly.

    Use DONE_WITH_CONCERNS if you completed the work but have doubts about correctness.
    Use BLOCKED if you cannot complete the task. Use NEEDS_CONTEXT if you need
    information that wasn't provided. Never silently produce work you're unsure about.
```

**Placeholders:** `[BRIEF_FILE]` from `scripts/task-brief`; `[PLAN_FILE]` the
plan's path; `[LEDGER_FILE]` from `scripts/sdd-workspace --ledger`;
`[REPORT_FILE]` named after the brief (`task-N-brief.md` → `task-N-report.md`);
`[ACTION_PERMISSIONS]` the outbound and shared-state actions the controller
allows — push, deploy, migration, production write — with unlisted ones denied;
local commits need no entry; `[FINDINGS_FILE]` the prior review on a fix
dispatch, otherwise `none`;
`[directory]` the working tree the worker runs in.
