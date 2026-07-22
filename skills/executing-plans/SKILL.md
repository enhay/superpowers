---
name: executing-plans
description: Use when executing a written implementation plan whose tasks are tightly coupled or better handled by the main agent than by fresh workers.
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

Use `subagent-driven-development` instead when plan tasks are independently implementable and reviewable. Do not prefer delegation merely because workers are available.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create todos for the plan items and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified, report the plan outcome and remaining branch state. Use `finishing-a-development-branch` only when the user has explicitly asked to finish or integrate the branch.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Related workflow skills:**
- **using-git-worktrees** - Use only when the user or plan requires isolation.
- **writing-plans** - Creates the plan this skill executes.
- **finishing-a-development-branch** - Use only after an explicit finish or integration request.
