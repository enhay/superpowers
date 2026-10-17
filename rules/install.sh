#!/usr/bin/env bash
# Link the global agent rules and the forked skills into place on this machine.
# Idempotent. An existing regular file is moved aside as <file>.bak-<timestamp>.
# The rules hard-code /Users/zhaohua paths, so this expects the same username.
set -euo pipefail

FORK="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak-$STAMP"
    echo "backup  $dst.bak-$STAMP"
  fi
  ln -sfn "$src" "$dst"
  echo "link    $dst -> $src"
}

link "$FORK/rules/home/CLAUDE.md"   "$HOME/CLAUDE.md"
link "$FORK/rules/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$FORK/rules/claude/RTK.md"    "$HOME/.claude/RTK.md"
link "$FORK/rules/codex/AGENTS.md"  "$HOME/.codex/AGENTS.md"
link "$FORK/rules/codex/RTK.md"     "$HOME/.codex/RTK.md"
link "$FORK/rules/grok/AGENTS.md"   "$HOME/.grok/AGENTS.md"

# Claude Code and Codex do not read ~/.agents/skills; Grok reads it through
# [skills] paths in ~/.grok/config.toml.
for dir in "$FORK"/skills/*/; do
  name="$(basename "$dir")"
  link "$FORK/skills/$name"          "$HOME/.agents/skills/$name"
  link "$HOME/.agents/skills/$name"  "$HOME/.claude/skills/$name"
  link "$HOME/.agents/skills/$name"  "$HOME/.codex/skills/$name"
done

grep -q '\.agents/skills' "$HOME/.grok/config.toml" 2>/dev/null \
  || echo "note    add [skills] paths = [\"$HOME/.agents/skills\"] to ~/.grok/config.toml"
