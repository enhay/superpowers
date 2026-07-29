---
name: subagent-driven-development
description: Use when executing a written implementation plan whose tasks are independently implementable and reviewable and whose approved commit boundaries provide isolated task diffs. Do not use for trivial, tightly coupled, or no-commit work.
---

# Subagent-Driven Development

Execute a durable plan by dispatching a fresh implementer per task, reviewing each
task, and running one broad review at the end. Workers never inherit your session
history — you construct exactly the context each one needs, which also keeps your
own context free for coordination.

**Dispatch** here means: start a worker that does not inherit this conversation's
history, by whatever mechanism the harness provides. The prompt templates in this
skill are the worker's message — content, not a call signature.

Use this only when the plan exists, its tasks are mostly independent, and it
authorizes task-level commits (review and recovery both depend on isolated task
diffs). Commit authority comes from the user, a project rule, or a plan the user
approved — a plan you wrote yourself does not create it. Without that authority, or
when tasks are tightly coupled, execute the plan yourself, serially, in the current
checkout. Never push unless the user asks.

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

Scan the plan once before Task 1 for tasks that contradict each other or the
Global Constraints, and for anything the plan mandates that the review rubric
treats as a defect. Present all findings as one batched question — each beside the
plan text that mandates it, asking which governs. Clean scan: proceed silently.

## Per-task loop

1. `scripts/task-brief PLAN_FILE N` → brief file path.
2. Record BASE (current HEAD) before dispatching.
3. Dispatch implementer with [implementer-prompt.md](implementer-prompt.md).
4. Answer any questions, then let it implement, verify, commit, self-review.
5. `scripts/review-package BASE HEAD` → diff file path.
6. Review the task. Prefer the harness's own review capability, handing it the
   brief as its custom review instructions and the package as its diff; only when
   the harness has none, dispatch a worker with
   [task-reviewer-prompt.md](task-reviewer-prompt.md). Follow the reviewer's own
   output contract rather than imposing a second one.
7. Dispatch one fix worker for the findings that block the task, then re-review.
8. Append one line to the ledger and move on.

Spec compliance is yours to adjudicate either way: a native reviewer reports
defects in the code, not whether the task matched the brief it was given.

BASE is the commit you recorded, never `HEAD~1` — that silently drops all but the
last commit of a multi-commit task.

After the last task, run one broad whole-change review over
`scripts/review-package MERGE_BASE HEAD`. Resolve MERGE_BASE from the plan, the
project's stated integration branch, or the current branch's upstream — never
assume `main` exists. Use the harness's own review capability where one exists;
otherwise reuse the task reviewer template with the branch package as its diff. If
it returns findings, dispatch ONE fix worker with the complete list — per-finding
fixers each rebuild context and re-run suites, and cost more than the tasks did.

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

- **DONE** — generate the review package, dispatch the reviewer.
- **DONE_WITH_CONCERNS** — read the concerns first. Correctness or scope concerns
  get resolved before review; observations get noted.
- **NEEDS_CONTEXT** — supply what was missing, re-dispatch.
- **BLOCKED** — diagnose before retrying: missing context → provide it; needs more
  reasoning → more capable model; too large → split; plan is wrong → escalate to
  the user. Never force the same model to retry unchanged.

A reviewer's "⚠️ cannot verify from diff" items do not block the review, but you
resolve each one yourself before marking the task complete — you hold the plan and
cross-task context the reviewer lacks. A confirmed gap is a failed spec review.

## Constructing reviewer prompts

Per-task reviews are task-scoped gates; breadth belongs to the final review.

- Never pre-judge findings. If your prompt contains "do not flag", "don't treat X
  as a defect", "at most Minor", or "the plan chose" — stop. Let the reviewer raise
  it and adjudicate in the loop.
- No open-ended directives ("check all uses", "run race tests if useful") without a
  concrete task-specific reason, and no repeating verification the implementer
  already ran unless reading raises a real doubt.
- The global-constraints block is the reviewer's attention lens: copy binding
  requirements verbatim from the plan — exact values, formats, and stated
  relationships between components. Process rules are already in the template.
- A dispatch describes one task, not the session's history. Never paste prior-task
  summaries; a real session hit 42k chars of which 99% was pasted history.
- A finding that conflicts with what the plan mandates is the user's decision:
  present the finding and the plan text, ask which governs. Do not dismiss it, and
  do not dispatch a contradicting fix without asking.
- Every fix dispatch carries the implementer contract — re-run the smallest
  verification covering the change and report the observed outcome, command, and
  result. Confirm that before re-dispatching the reviewer.
- Record Minor findings in the ledger and point the final review at that list. A
  roll-up nobody reads is a silent discard.

## File handoffs

Everything pasted into a dispatch, and everything a subagent prints back, stays
resident in your context and is re-read every turn. Move artifacts as files:

- **Brief** — from `scripts/task-brief`. The dispatch carries only: one line on
  where the task fits, the brief path introduced as "read this first — it is your
  requirements, use its exact values verbatim", interfaces and decisions from
  earlier tasks the brief cannot know, your resolution of any ambiguity you spotted,
  and the report path plus report contract. Exact values live only in the brief.
- **Report** — name it after the brief (`task-N-brief.md` → `task-N-report.md`).
  The implementer writes detail there and returns only status, commits, a one-line
  verification summary, and concerns.
- **Reviewer inputs** — brief path, report path, review package path, plus the
  binding global constraints.
- Fix dispatches append their fix report to the same report file.

## Durable progress

Conversation memory does not survive compaction; controllers that lost their place
have re-dispatched entire completed sequences — the most expensive failure observed.

- At start, read `"$(git rev-parse --show-toplevel)/.superpowers/sdd/progress.md"`.
  Tasks marked complete there are done; resume at the first that is not.
- On a clean review, append `Task N: complete (commits <base7>..<head7>, review clean)`.
- After compaction, trust the ledger and `git log` over your own recollection.
- `git clean -fdx` destroys the ledger (git-ignored scratch); recover from `git log`.

## Never

- Dispatch the first implementer while the tree holds uncommitted changes you did
  not make — ask the user first, never clear them yourself.
- Create or switch branches, or create a worktree, without user, project, or
  approved-plan authority.
- Run implementation subagents in parallel, or let two workers touch one workspace.
- Hand a subagent the whole plan file instead of its brief, or a reviewer no diff file.
- Skip a verdict: spec compliance AND task quality are both required.
- Move to the next task with open Critical/Important findings, or let implementer
  self-review replace review.
- Re-dispatch a task the ledger already marks complete.
