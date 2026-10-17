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
- `rules/` is a snapshot of the global instruction files for other machines;
  the originals under `~` stay authoritative, and `rules/install.sh` copies the
  snapshot into place. This repo is public: no credentials or hosts there.
- Skill text stays harness-neutral — the same files are read by more than one runtime.
