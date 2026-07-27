# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- Selected skill directories are symlinked into `~/.agents/skills`; Claude links to the same directories from `~/.claude/skills`.
- Do not edit Codex or Claude plugin caches.
- `using-superpowers`, `brainstorming`, and `dispatching-parallel-agents` are present in the source but not exposed by default.
- `writing-plans` uses contract-level plans and the commit -> plan -> spec escalation rule, but only after a durable plan/spec operation is actually requested or established. Planning-policy discussion, artifact existence questions, and narrow document fact checks stay on direct inspect/answer. Multiple repositories or services do not trigger a spec by themselves: coordinated internal producers and consumers default to one final contract, one plan, and one release. Concurrency hardening, mixed-version compatibility, and staged rollout require a named real-world trigger rather than hypothetical scale.
- `subagent-driven-development` follows plan-defined verification, uses TDD only when explicitly required, and requires plan-authorized task commits for isolated review and recovery; no-commit plans use `executing-plans`.
- `executing-plans` treats plans as live documents and does not require branch isolation by default; both execution skills ask before working over pre-existing uncommitted changes.
- Code review skills trigger only from explicit review requests or approved workflow boundaries, and only at a code change — never at a plan, spec, or other document; reviewer prompts are evidence-first and scope-bounded. Speculative robustness findings (race, retry, null-safety, input validation) require a named trigger, and unjustified defensive code is itself a finding.
- `writing-plans` carries the plan/spec review checklist; plan review is main-agent work, never a reviewer subagent.
- SDD worker and reviewer prompts carry the default-deny assertion whitelist; `verification-before-completion` carries the consumer-path, quantify-before-negative, and visual-gate traps.
- A worker may fix a real defect on the call path its task touches if it declares the fix separately; adjacent cleanup and unrelated gaps are reported, not fixed. The reviewer judges a declared fix on its merits instead of flagging it as out of scope.
- `systematic-debugging`, `test-driven-development`, and `writing-skills` carry local narrow-trigger overrides.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag, and cherry-pick the local customization commits. Review upstream changes before resolving conflicts; do not track unreleased `main` by default.
