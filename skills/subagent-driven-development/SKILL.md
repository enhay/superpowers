---
name: subagent-driven-development
description: Use when executing a written implementation plan and either one or more bounded delivery slices benefit from fresh worker context or delegation, or the user explicitly requests subagent execution. Do not invoke proactively for trivial work or when dispatch and review overhead exceed the benefit; never delegate work whose ownership cannot be separated safely.
---

# Subagent-Driven Development

Execute a durable plan by delegating bounded delivery slices where a fresh worker
adds value. This is the job a project manager plus a PR reviewer does: cut the
work into pieces one person can own, hand over enough context to start, then judge
what comes back against what was asked. That judgment is yours and nothing below
replaces it — the rules exist for the few things that are easy to lose while
managing several workers: ownership, permissions, and durable progress.

A plan task is a candidate responsibility boundary, not a mandatory
one-worker/one-commit/one-review unit. The controller may combine adjacent tasks,
keep tightly coupled work local, or split a task after code inspection.

Workers may not inherit your session history. Construct the smallest context that
lets them act independently: the plan path, a task-local brief, current integration
facts, explicit ownership, verification, and permissions. Do not replace missing
decisions with a longer implementation recipe.

Over-splitting destroys that. A worker's cold start costs it once, then goes.
Whatever you relay between dispatches — interfaces, findings, `⚠️ cannot verify`
items — stays resident and is re-read every turn. Splitting one coherent piece
across an explorer, an implementer, a reviewer and a fixer pays orientation four
times over the same files and moves the cost onto you permanently.

**Dispatch** here means: start a worker that does not inherit this conversation's
history, by whatever mechanism the harness provides. The prompt templates in this
skill are the worker's message — content, not a call signature.

Use this when the plan exists and either a slice has a clear responsibility
boundary with useful delegation value, or the user explicitly asks for subagent
execution. An explicit request overrides the overhead preference, not ownership or
workspace safety: choose the smallest coherent safe dispatch instead of inventing
parallelism. Workers commit their slice by default: local commits are revertible
and leave nothing, and they are what gives review and rollback a boundary per
slice. The question that needs an answer is the workspace, not the action — do
not commit in a checkout carrying unknown WIP; ask whether to take a worktree
instead. In one shared workspace, run implementation workers sequentially. Never
push, deploy, migrate, or write to production unless the user asks.

Verification follows the plan and project rules: the smallest direct evidence that
proves each deliverable, and a test only where a later change would break the
behavior silently and nothing else would catch it. TDD only when the user or a
project rule requires it.

**Narration:** at most one short line between tool calls — the ledger and tool
results carry the record.

**Continuous execution:** do not check in between tasks. Stop only for an
unresolvable BLOCKED status, ambiguity that genuinely prevents progress, or
completion.

## Pre-flight

Read the plan and the current workspace state. The plan is authoritative for its
goal, acceptance, binding decisions, and public or cross-slice contracts. Code is
authoritative for reversible implementation details and current wiring. Re-open
the plan when a decision or acceptance question arises; avoiding a second read is
not worth relying on stale memory.

Execution-readiness check, not a second full plan review. Four things block a
dispatch:

1. **Contradictory binding decisions** — one slice requires what another binding
   decision forbids.
2. **Ownership cannot be isolated** — the worker would overlap unknown local WIP,
   or two active workers would edit the same workspace. Unrelated dirty files do
   not block a clearly disjoint slice.
3. **Missing authority for the requested action** — push, deploy, migration,
   production write, or another external mutation. Local commits are not in this
   class and block nothing; what blocks is committing over unknown WIP, which is
   check 2.
4. **Something the plan mandates that the review rubric calls a defect** — a task
   that instructs what a reviewer must then flag. Those two cannot both be
   satisfied and the user chooses which governs.

One message for all of them: plan line number, the clause in under a line, what
it collides with. No surrounding paragraphs — the user has the plan. Past about
three collisions stop enumerating; a plan contradicting itself that often needs
another pass, not twelve adjudications.

Nothing else is pre-flight's business. Clean scan: proceed silently.

## Execution loop

Choose the next coherent slice after reading the plan and current code. One
dispatch may cover one task, several adjacent tasks, or a bounded part of one
task. Optimize for ownership and integration, not task-count fidelity.

Per dispatch:

1. Record the starting state of every repository, inspect dirty files, and set
   `SDD_HOME` to the repository carrying the main change before creating any SDD
   artifact. Name the worker's ownership explicitly; do not invent an exact file
   list when discovery is part of the task, but stop if discovered files overlap
   unknown WIP.
2. `scripts/task-brief PLAN_FILE N` → brief file path. It also accepts `2-4` or
   `2,4,5` when adjacent plan tasks form one coherent implementation slice.
3. Dispatch a worker with [implementer-prompt.md](implementer-prompt.md). Pass the
   plan path, brief, current integration facts, and verification target; it
   commits its slice unless the workspace check above says otherwise. The worker
   inspects, implements, verifies, and self-critiques. There is no separate
   explorer unless a literal search and local inspection failed before dispatch.
4. Resolve `NEEDS_CONTEXT` or a genuine blocker. Reversible local choices belong
   to the worker; product, data, permission, public-contract, and irreversible
   choices return to the controller.
5. Inspect the report and actual changed files. Record the dispatch BASE and use
   `scripts/review-package -C REPO BASE HEAD` when a commit range is useful. When
   a slice could not be committed, use the harness's workspace review or create an
   explicit diff artifact limited to files that were clean at the dispatch
   boundary. If the change cannot be isolated from prior work, widen the
   review to the combined change instead of claiming a task-scoped diff.
6. The controller always checks outcome, scope, evidence, and the open choices
   the worker settled on its own. Add independent
   review when the user requests it, the worker reports correctness concerns, or
   the slice changes a public/cross-repository contract, data semantics,
   permissions, irreversible state, or several interacting components. For a
   low-risk local slice, controller inspection plus direct verification is enough.
   Prefer the harness's native review; otherwise use
   [task-reviewer-prompt.md](task-reviewer-prompt.md).
7. Resolve blocking findings. A focused fix may be applied directly; a broader
   fix can return to one worker with the review file. Re-review the changed scope,
   not unrelated work that already passed.
8. Record the observed result, verification, review level, and any dependency
   change in the ledger, then continue.

Spec compliance remains the controller's responsibility. A reviewer can find
defects in the presented change, but does not own product adjudication or hidden
cross-task context.

A task whose deliverable is evidence or a decision rather than code — a
measurement that sets a threshold, an input matrix that fixes a config's scope —
does not enter this loop. It needs the cross-repository and production context you
already hold, produces no reviewable diff, and its output usually edits the plan.
Do it yourself and record the result there.

Before reporting the plan complete, review the assembled change against the plan's
acceptance conditions. The code is the fact — check them there, not against your
record of which tasks passed. At its lightest this is you reading the change and
naming where each condition is met; a condition nothing meets is exactly what
every task passing its own review cannot tell you, and a slice whose plan text
changed after it was built surfaces here too. Scale up from there: dispatch a
broad whole-change review when multiple dispatches interact, the change crosses
repositories or public boundaries, or the user requests it, using the harness's
own review capability or [final-review-prompt.md](final-review-prompt.md). Do not
point the task reviewer template at a whole branch.

## Model selection

Only when the harness lets you choose a worker's model, and you know what its
options map to. Where it does, specify explicitly — an omitted model usually
inherits your session's, which is usually the most expensive one. Where it does
not, skip this section entirely rather than inventing a model name.

Match the model to the work: transcription of complete plan code or a single-file
mechanical fix takes the cheapest tier; multi-file integration and prose-described
implementation take a mid tier as the floor; architecture, design, and the final
whole-change review take the most capable. Reviewers scale with the diff's risk,
not its existence.

Turn count beats token price — the cheapest models routinely take 2-3× the turns on
multi-step work and cost more overall.

## Handling implementer status

- **DONE** — inspect the report and change, then choose the proportional review
  path above.
- **DONE_WITH_CONCERNS** — read the concerns first. Correctness or scope concerns
  get resolved before review; observations get noted.
- **NEEDS_CONTEXT** — supply what was missing, re-dispatch.
- **BLOCKED** — diagnose before retrying: missing context → provide it; needs more
  reasoning → more capable model; too large → split; plan is wrong → escalate to
  the user. Never force the same model to retry unchanged.

A reviewer's "⚠️ cannot verify from diff" items do not automatically block the
change. Resolve those that cover acceptance, a binding decision, or a material
risk before claiming completion; leave irrelevant diff limitations as such.

Most cost nothing — the answer is in the plan or an earlier ledger entry, already
in front of you. For the rest, hand them to the fix worker as questions rather
than searching yourself and carrying the output. Many of them at once means the
task was drawn too small for its own diff to answer for it; size the next one up.

## Constructing reviewer prompts

When independent task review is warranted, keep it scoped to the presented slice;
breadth belongs to a whole-change review.

- Never pre-judge findings. If your prompt contains "do not flag", "don't treat X
  as a defect", "at most Minor", or "the plan chose" — stop. Let the reviewer raise
  it and adjudicate in the loop.
- No open-ended directives ("check all uses", "run race tests if useful") without a
  concrete task-specific reason, and no repeating verification the implementer
  already ran unless reading raises a real doubt.
- The reviewer gets the plan's path, not decisions pasted into the prompt. Name
  only the binding decision IDs relevant to this slice; exact values live in the
  plan. When none apply, say so instead of inventing one.
- A dispatch describes one task, not the session's history. Never paste earlier
  tasks' summaries; a real session hit 42k chars of which 99% was pasted history.
- A finding that conflicts with what the plan mandates is the user's decision:
  present the finding and the plan text, ask which governs. Do not dismiss it, and
  do not dispatch a contradicting fix without asking.
- Every fix dispatch carries the implementer contract — re-run the smallest
  verification covering the change and report the observed outcome, command, and
  result. Confirm that before re-dispatching the reviewer.
- Record deferred findings only when the assembled change may make them
  consequential. Do not accumulate polish observations merely to feed a final
  ceremony.

## File handoffs

Everything pasted into a dispatch, and everything a subagent prints back, stays
resident in your context and is re-read every turn. Move artifacts as files:

- **Plan** — hand over the path. A few thousand words costs a worker nothing;
  withholding it makes you relay by hand what it could read for free — constraints
  pasted into every reviewer dispatch, earlier interfaces retyped into every
  implementer dispatch. Those pastes are the actual cost: resident, re-read every
  turn. A worker that can see the goal, the architecture, the rejected
  alternatives and its neighbouring tasks makes the judgments you would otherwise
  field as questions.
- **Brief** — from `scripts/task-brief`. It marks outcome and responsibility, not
  an implementation recipe. The dispatch carries the plan path, ledger path,
  brief path, current integration facts, explicit permissions, and report path.
  Binding-decision IDs are exact; their values remain in the plan. Local path
  hints remain evidence to verify.
- **Report** — name it after the brief (`task-2-4-brief.md` → `task-2-4-report.md`).
  The implementer writes detail there and returns only status, commits if any, a
  one-line verification summary, and concerns.
- **Reviewer inputs** — plan path, brief path, implementer report path, explicit
  diff artifact or native workspace change, plus relevant binding-decision IDs.
- **Review output** — a file too, named after the brief (`task-N-review.md`). The
  reviewer returns verdicts, severity counts, one line per blocking finding, and
  the path; the fix worker reads the file. A reviewer that prints its full report
  puts every Minor finding in your context for the rest of the run. A re-review
  writes a fresh round file (`task-N-review-round-2.md`) and reads the prior file;
  never overwrite the findings being adjudicated.
- Fix dispatches append their fix report to the same report file.

## Durable progress

Conversation memory does not survive compaction; controllers that lost their place
have re-dispatched entire completed sequences — the most expensive failure observed.

Committed slices carry their own progress: `git log` says which are done and what
each produced, it survives compaction, and it cannot drift from the code. Name
the slice in the commit subject and keep no second copy of that information.

A ledger is the fallback for what commits cannot hold — slices that had to stay
uncommitted, so the workspace is one undifferentiated diff:

- `scripts/sdd-workspace --ledger PLAN_FILE` → ledger path. Read it at start:
  tasks marked complete there are done; resume at the first that is not.
- The script writes the first line, `plan: <path> @ <revision>`, and rotates a
  ledger belonging to a different plan aside rather than appending to it — a
  worktree runs several plans over time and a stale entry read as current
  progress is the failure this prevents. It warns on stderr if it cannot write
  under the git directory; that fallback is destroyed by `git clean -fdx`.
- On completion append `Task N: complete`, and under it only what a later task
  depends on and cannot see in a diff of its own — an interface that gained a
  parameter, a name that changed. Verification results and review levels belong
  to the dispatch that produced them and go no further; a slice that failed
  either one is not complete.
- After compaction, trust `git log` and the current diff over your own
  recollection.

The ledger is execution-window state, not a record — never committed, never
written into commit messages, and living under the git directory only so
`git clean -fdx` cannot destroy it mid-run.

Write something back into the plan when leaving it out would cost later: a finding
deliberately left unfixed, an adjudication between a finding and the plan's own
wording, a premise a task disproved that a later task still rests on. That is a
judgment about what would otherwise be re-argued, not a step to run after every
task — and it is the plan's own content changing, not a log appended to it.

## Never

- Dispatch an implementer into files carrying unknown uncommitted changes. Disjoint
  user WIP is preserved and does not by itself block a bounded slice.
- Create or switch branches, or create a worktree, without explicit user or
  project authority. A plan may record that authority but does not create it.
- Run implementation subagents in parallel, or let two workers touch one workspace.
- Withhold the plan from a worker. Hand over its path — a plan is a few thousand
  words, and relaying its contents by hand costs you far more than it costs them.
  Give a reviewer no diff file, though: that one is not optional.
- Let a worker's self-critique replace controller verification, or skip an
  independent review when the risk triggers above require one.
- Move on with an open blocking finding that affects the accepted outcome.
- Re-dispatch a task the ledger already marks complete.
- Point the task reviewer at a whole branch, or at a fix-only diff, as a spec
  gate. Its brief comparison assumes the diff contains the whole task.
- Let a worker remove a lock, retry, checkpoint, idempotency, permission or
  financial guard on its own judgement — it proposes with search evidence, you
  decide.
- Pretend a task-scoped diff is isolated when it also contains earlier or unknown
  work. Review the combined change or change the execution boundary.
