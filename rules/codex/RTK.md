# RTK - Rust Token Killer (Codex CLI)

**Usage**: Token-optimized CLI proxy for shell commands.

## Rule

Use `rtk` for high-noise, human-readable output where truncation, grouping, or
deduplication does not affect the conclusion. Typical cases include exploratory
`rg`/`find`, repetitive logs, dependency listings, and routine test/build runs
where only the exit status or failure summary matters.

Use the original command, or `rtk proxy <cmd>`, whenever completeness or exact
representation is required. This includes:

- dirty-worktree and final diff checks;
- reference, registration, router, or boot-wiring searches before deleting or
  renaming symbols;
- production diagnosis, SQL/JSON data, exact counts, ordered output, and full
  stack traces;
- output consumed by another command or script.

For uncertain cases, use RTK to locate the issue, then repeat the decisive check
with unfiltered output before drawing a completeness-sensitive conclusion such
as "no matches", "all empty", or "never occurred".

Examples:

```bash
rtk git status
rtk cargo test
rtk npm run build
rtk pytest -q

# Preserve complete output when it is evidence
rtk proxy git status --short
rtk proxy git diff
rtk proxy rg 'symbolName' .
```

## Meta Commands

```bash
rtk gain            # Token savings analytics
rtk gain --history  # Recent command savings history
rtk proxy <cmd>     # Run raw command without filtering
```

## Verification

```bash
rtk --version
rtk gain
which rtk
```
