---
name: writing-skills
description: Use when designing or substantially restructuring a cross-project, discipline-enforcing skill whose triggers or behavioral rules are uncertain and need scenario validation.
---

# Writing Skills

## Entry condition

Use this workflow for uncertain, reusable behavioral design. Do not use it for localized wording, metadata, formatting, mechanical updates, or trigger narrowing that already has a concrete observed failure. Handle those directly with `inspect -> edit -> validate`.

## Workflow

1. Define concrete requests that should and should not trigger the skill.
2. Use an existing transcript or failure as the baseline when one is available.
3. Write the smallest trigger and body guidance that addresses the observed failure.
4. Validate frontmatter and referenced resources.
5. Run proportionate scenario checks only when behavior remains uncertain.

Do not automatically create plans, spawn subagents, or require repeated pressure tests. Use those only when independent sampling is necessary to resolve real ambiguity.

For a brand-new skill scaffold or substantial bundled resources, use `skill-creator` for Codex format and validation requirements.
