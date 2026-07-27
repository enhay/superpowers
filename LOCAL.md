# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- Selected skill directories are symlinked into `~/.agents/skills`; Claude links to the same directories from `~/.claude/skills`.
- Do not edit Codex or Claude plugin caches.
- `using-superpowers`, `brainstorming`, and `dispatching-parallel-agents` are present in the source but not exposed by default.
- `writing-plans` chooses the artifact from delivery shape: no durable artifact for direct answers/local changes, one plan for one coordinated outcome, and spec then plans only when multiple independent plans share durable decisions or the user explicitly requests a spec. Planning-policy discussion, artifact existence questions, and narrow document fact checks stay on direct inspect/answer. UX, data semantics, public interfaces, repository count, and service count do not force a spec. Concurrency hardening, mixed-version compatibility, and staged rollout require a named real-world trigger rather than hypothetical scale.
- `subagent-driven-development` follows plan-defined verification, uses TDD only when explicitly required, and requires plan-authorized task commits for isolated review and recovery; no-commit plans use `executing-plans`.
- `executing-plans` treats plans as live documents and does not require branch isolation by default; both execution skills ask before working over pre-existing uncommitted changes.
- Code review skills trigger only from explicit review requests or approved workflow boundaries, and only at a code change — never at a plan, spec, or other document; reviewer prompts are evidence-first and scope-bounded. Speculative robustness findings (race, retry, null-safety, input validation) require a named trigger, and unjustified defensive code is itself a finding.
- `writing-plans` carries the plan/spec review checklist; plan review is main-agent work, never a reviewer subagent.
- SDD worker and reviewer prompts carry the default-deny assertion whitelist; `verification-before-completion` carries the consumer-path, quantify-before-negative, and visual-gate traps.
- A worker may fix a real defect on the call path its task touches if it declares the fix separately; adjacent cleanup and unrelated gaps are reported, not fixed. The reviewer judges a declared fix on its merits instead of flagging it as out of scope.
- `systematic-debugging`, `test-driven-development`, and `writing-skills` carry local narrow-trigger overrides.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag, and cherry-pick the local customization commits. Review upstream changes before resolving conflicts; do not track unreleased `main` by default.
