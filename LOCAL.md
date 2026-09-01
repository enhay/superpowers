# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- `~/.agents/skills`, `~/.claude/skills`, and `~/.codex/skills` expose the same
  files through symlinks. Grok reads `~/.agents/skills` from its config. Never
  edit a runtime's plugin cache.
- Three skills ship: `grilling`, `writing-plans`, and
  `subagent-driven-development`.
- Each skill contains only workflow choices that materially change agent
  behavior. Global instructions own shared authority, workspace, verification,
  and coding rules; the model owns ordinary reasoning and reversible local
  implementation choices.

## Why these three remain

Each carries judgement a capable model does not supply on its own, and each is
reachable by a routing signal the model will actually notice.

- `grilling` keeps unsettled requirements in conversation and writes no file. It
  governs how to interrogate the user — the behavior global rules reach least and
  the model defaults worst at.
- `writing-plans` chooses and writes a durable, decision-complete artifact only
  after agreement exists. Its template and paths are project convention that
  cannot be derived.
- `subagent-driven-development` carries what the controller cannot recover once
  workers run: shared-checkout concurrency hazards, model routing, and the fact
  that a worker's summary is a claim rather than proof.

Everything else from upstream is intentionally absent:

- `using-superpowers`, `dispatching-parallel-agents`, `executing-plans`,
  `verification-before-completion`, `requesting-code-review`, and
  `receiving-code-review` duplicate native agent or harness behavior.
- `brainstorming` overlaps `grilling` but adds an unconditional artifact flow.
- `test-driven-development` is opt-in by user or project rule.
- `using-git-worktrees` and `finishing-a-development-branch` belong in global
  workspace rules.
- `writing-skills` is replaced by the runtime's skill creator.
- `systematic-debugging` described the debugging a capable model already performs,
  and its trigger — a defect that direct inspection cannot explain — arrives when
  the model is deepest in the problem and least likely to stop and route to a
  skill. Its two load-bearing judgements moved into the global rules, which load
  every turn: trace the failing value to the boundary where it first diverges, and
  replace a disproved hypothesis rather than stacking another speculative fix.

The delegation skill deliberately has no fixed worker prompts or
brief/ledger/review-package toolchain. Current agents can carry scoped context
directly, and fixed scaffolding adds ceremony, duplicates global rules, and ages
faster than the harness.

## Updating

Fetch upstream tags, create `local/<version>` from the new stable tag, and
cherry-pick local customization commits. Review only the four retained skills.
`grilling` is local-only and has no upstream counterpart.

When adding or removing a skill, update this file, the symlink roots, the
explicit-request tests, and the skill-list line in `~/CLAUDE.md`,
`~/.codex/AGENTS.md`, and `~/.grok/AGENTS.md`.

A skill earns its place only when it carries judgement the model lacks *and* a
routing signal it will notice. Prose the model supplies unprompted is not free:
length is weight, so a paragraph arguing that some step is optional still pushes
toward taking it, and a template's empty section pulls harder than the sentence
telling you to omit it.
