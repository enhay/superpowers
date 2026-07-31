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
  the user asks. A plan is written for two readers: a person reviewing it as a
  product document and technical proposal, and an implementer executing it — text
  that helps the first understand the change is not residue to be cut. A
  decision's basis is recorded as dated history and a claim about the system's
  present state carries the check that established it, so an old fact cannot
  silently pollute a later plan; superseded decisions are marked in place rather
  than deleted, and facts are referenced across plans by path, never copied.
  A plan states its core need — the smallest form that delivers value, with the
  volume that makes "too heavy" judgable — and plans that. Capabilities outside
  it (degradation, high availability, compatibility, projection machinery) are
  neither added nor deferred unilaterally: each is named and asked about, and
  silence means out of scope. The plan says what to build and not what it
  declined to build, because naming discarded designs loads them into the
  implementer's context and sets the granularity at which he weighs his own
  forks; durable rationale lives in the spec. Review asks core need and
  proportion first, before eleven local checks pull the reviewer into details he
  will not come back out of. Plans are
  decision-complete and implementation-open: they bind
  outcomes, semantics, contracts, and irreversible choices, not local file/function
  design or execution choreography. Independent plan review is optional when the
  user asks or a high-risk decision benefits from a fresh pass. When delegation
  adds no value, the main agent executes directly through normal inspect,
  implementation, and verification without creating SDD artifacts.
- `subagent-driven-development` delegates bounded plan slices when fresh context
  adds value or the user explicitly requests subagent execution. Explicit requests
  override the overhead preference, not ownership or workspace safety. Workers
  commit their own slice by default — the gate is the workspace, not the action,
  so committing over unknown WIP is what blocks — and `git log` carries progress,
  leaving the ledger as a fallback for slices that stayed uncommitted. Push,
  deploy, migration and production writes still need explicit authority.
  Shared-workspace workers run sequentially, controller review is always
  required, and independent task/final review scales with risk instead of running
  ceremonially. Its prompts retain the
  assertion whitelist, three-tier defect rule, and the named-trigger rule for
  speculative robustness in both directions.
- Concurrency hardening, mixed-version compatibility, and staged rollout require a
  named real-world trigger rather than hypothetical scale.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag,
and cherry-pick the local customization commits. Most upstream skill changes are
irrelevant now — only the three kept skills need review before merging.
