# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- `~/.agents/skills`, `~/.claude/skills`, and `~/.codex/skills` expose the same
  files through symlinks. Grok reads `~/.agents/skills` from its config. Never
  edit a runtime's plugin cache.
- Four skills ship: `grilling`, `writing-plans`,
  `subagent-driven-development`, and `systematic-debugging`.
- Each skill contains only workflow choices that materially change agent
  behavior. Global instructions own shared authority, workspace, verification,
  and coding rules; the model owns ordinary reasoning and reversible local
  implementation choices.

## Why these four remain

- `grilling` keeps unsettled requirements in conversation and writes no file.
- `writing-plans` chooses and writes a durable, decision-complete artifact only
  after agreement exists.
- `subagent-driven-development` defines delegation ownership, safe concurrency,
  proportional review, and controller integration while relying on native todo
  and messaging capabilities.
- `systematic-debugging` activates only after direct inspection fails and
  requires evidence for the causal boundary before a fix is proposed.

Everything else from upstream is intentionally absent:

- `using-superpowers`, `dispatching-parallel-agents`, `executing-plans`,
  `verification-before-completion`, `requesting-code-review`, and
  `receiving-code-review` duplicate native agent or harness behavior.
- `brainstorming` overlaps `grilling` but adds an unconditional artifact flow.
- `test-driven-development` is opt-in by user or project rule.
- `using-git-worktrees` and `finishing-a-development-branch` belong in global
  workspace rules.
- `writing-skills` is replaced by the runtime's skill creator.

The delegation skill deliberately has no fixed worker prompts or
brief/ledger/review-package toolchain. Current agents can carry scoped context
directly, and fixed scaffolding adds ceremony, duplicates global rules, and ages
faster than the harness.

## Updating

Fetch upstream tags, create `local/<version>` from the new stable tag, and
cherry-pick local customization commits. Review only the four retained skills.
`grilling` is local-only and has no upstream counterpart.

When adding or removing a skill, update this file, the symlink roots, and the
skill-list line in `~/CLAUDE.md`, `~/.codex/AGENTS.md`, and
`~/.grok/AGENTS.md`.
