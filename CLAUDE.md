# Local Fork — Working Notes

This is a private fork. It is never contributed back upstream, so upstream's
contribution rules do not apply here and have been removed.

Read `LOCAL.md` before changing anything: it records which skills ship, why the
rest were removed, and how the symlinks reach each runtime.

- Edit skills here, never in a runtime's plugin cache.
- Adding or removing a skill means updating `LOCAL.md`, the two symlink roots that
  mirror `~/.agents/skills` (`~/.claude/skills`, `~/.codex/skills`), and the skill
  list line in all three global instruction files (`~/CLAUDE.md`,
  `~/.codex/AGENTS.md`, `~/.grok/AGENTS.md`). Grok needs no symlink — its
  `~/.grok/config.toml` reads `~/.agents/skills` directly.
- The global instruction files live in `rules/`; the paths under `~` are symlinks
  created by `rules/install.sh`. This repo is public: no credentials or hosts there.
- Skill text stays harness-neutral — the same files are read by more than one runtime.
