# Local Fork — Working Notes

This is a private fork. It is never contributed back upstream, so upstream's
contribution rules do not apply here and have been removed.

Read `LOCAL.md` before changing anything: it records which skills ship, why the
rest were removed, and how the symlinks reach each runtime.

- Edit skills here, never in a runtime's plugin cache.
- Adding or removing a skill means updating `LOCAL.md`, the three symlink roots
  (`~/.agents/skills`, `~/.claude/skills`, `~/.codex/skills`), and the skill list
  line in both global instruction files.
- Skill text stays harness-neutral — the same files are read by more than one runtime.
