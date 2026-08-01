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
    review command; task and whole-change fallbacks live with
    `subagent-driven-development` and trigger in proportion to risk.
  - `using-git-worktrees`, `finishing-a-development-branch` — one global rule each.
  - `writing-skills` — `skill-creator` covers scaffolding.
- The three kept skills are self-contained: they carry their own triggers,
  artifact routing, and constraints, so global instructions do not restate them.
- `writing-plans` chooses the artifact from delivery shape — no durable artifact
  for direct answers and local changes, one plan for one coordinated outcome, and
  spec then plans only when multiple independent plans share durable decisions or
  the user asks. A plan is the baseline product requirement and technical
  proposal: it binds outcomes, semantics, contracts, and irreversible choices,
  while code and runtime evidence describe the current system. Plan changes follow
  goal, acceptance, durable decision, contract, dependency, and load-bearing
  premise changes; execution details stay with code, git, runtime evidence, or
  handoff artifacts.
- `subagent-driven-development` delegates only when a bounded outcome benefits
  from fresh context or the user asks. Workers inspect code, implement, verify,
  and commit by default; the controller judges the actual diff and acceptance.
  Shared-workspace workers run sequentially, and independent review scales with
  risk. The controller's active todo/checklist tracks execution; `git log` records
  committed outcomes and is read only for a targeted history question. Briefs,
  reports, review packages, and the ledger are optional handoff tools; the ledger
  is only for uncommitted facts that the diff cannot recover. Push, deploy,
  migration and production writes still need explicit authority. Prompts retain
  the assertion whitelist, three-tier defect rule, and named-trigger rule for
  speculative robustness.
- Concurrency hardening, mixed-version compatibility, and staged rollout require a
  named real-world trigger rather than hypothetical scale.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag,
and cherry-pick the local customization commits. Most upstream skill changes are
irrelevant now — only the three kept skills need review before merging.
