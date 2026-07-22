# Local Superpowers Fork

Upstream: `https://github.com/obra/superpowers`

Base release: `v6.1.1` (`d884ae04edebef577e82ff7c4e143debd0bbec99`)

Branch: `local/v6.1.1`

## Policy

- `~/.agents/sources/superpowers` is the editable source of truth.
- Selected skill directories are symlinked into `~/.agents/skills`; Claude links to the same directories from `~/.claude/skills`.
- Do not edit Codex or Claude plugin caches.
- `using-superpowers` and `brainstorming` are not exposed by default.
- `writing-plans` uses contract-level plans and the commit -> plan -> spec escalation rule.
- `subagent-driven-development` follows plan-defined verification and uses TDD only when explicitly required.
- `systematic-debugging`, `test-driven-development`, and `writing-skills` carry local narrow-trigger overrides.

## Updating

Fetch upstream tags, create a new `local/<version>` branch from the new stable tag, and cherry-pick the local customization commits. Review upstream changes before resolving conflicts; do not track unreleased `main` by default.
