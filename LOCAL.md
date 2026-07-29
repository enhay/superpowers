# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- Exposed skills are symlinked into `~/.agents/skills`, and both `~/.claude/skills`
  and `~/.codex/skills` link to those. Do not edit Codex or Claude plugin caches.
- Only three skills ship: `writing-plans`, `subagent-driven-development`,
  `systematic-debugging`. Everything upstream ships beyond these was removed
  because a current frontier model already does it, or because the rule belongs in
  global instructions instead of a skill:
  - `using-superpowers`, `brainstorming`, `dispatching-parallel-agents` — never exposed.
  - `executing-plans` — main-line execution needs no skill.
  - `test-driven-development` — TDD is opt-in per user or project rule.
  - `verification-before-completion` — the harness already requires honest reporting.
  - `requesting-code-review`, `receiving-code-review` — the harness ships its own
    review command; the final whole-change review uses it or reuses
    `task-reviewer-prompt.md` against a branch package.
  - `using-git-worktrees`, `finishing-a-development-branch` — one global rule each.
  - `writing-skills` — `skill-creator` covers scaffolding.
- The three kept skills are self-contained: they carry their own triggers,
  artifact routing, and constraints, so global instructions do not restate them.
- `writing-plans` chooses the artifact from delivery shape — no durable artifact
  for direct answers and local changes, one plan for one coordinated outcome, and
  spec then plans only when multiple independent plans share durable decisions or
  the user asks. UX, data semantics, public interfaces, and repository count do
  not force a spec. It also carries the plan/spec review checklist; plan review is
  main-agent work, never a reviewer subagent.
- `subagent-driven-development` requires plan-authorized task commits; without them,
  execute on the main line. Its worker and reviewer prompts carry the default-deny
  assertion whitelist, the three-tier defect rule (fix a real defect on the touched
  path and declare it separately; report adjacent and unrelated ones), and the
  named-trigger rule for speculative robustness in both directions.
- Concurrency hardening, mixed-version compatibility, and staged rollout require a
  named real-world trigger rather than hypothetical scale.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag,
and cherry-pick the local customization commits. Most upstream skill changes are
irrelevant now — only the three kept skills need review before merging.
