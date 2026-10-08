---
name: grilling
description: Use before writing a durable plan or spec when the need, load-bearing facts, or binding decisions are unsettled. Also use when the user asks to be interviewed or to stress-test an idea. Conversation only; never creates or edits files.
---

# Grilling

Reach a confirmed, shared understanding of the need and its binding decisions
before anything durable is written.

## Guidance

- The need comes from the user. Code tells you what constrains the need and what
  it costs, never what it is: "the system lacks X" describes code, not a goal.
  Separate independent outcomes and refine one at a time.
- Look facts up in code, data, and docs instead of asking the user to recall
  them, in parallel with the questions that do not depend on them.
- The user owns the goal and what done looks like, architecture, UX, business and
  data semantics, permissions, irreversible effects, contracts, and ordering that
  changes the result. Settle the rest from the current system: names, files,
  libraries, decomposition, worker and commit choices. Trace each binding
  decision to something the user said, or ask.
- Raise a new guard, fallback, compatibility path, or structure only when the
  global rules' scenario-and-condition test holds. Asking implies it was worth
  considering, and it tends to come back as a yes.
- Phrase each question as the business situation and what each answer makes
  happen. One that needs the code or a coined label to be understood is not
  ready to ask.

## Constraints

1. Create or edit no files.
2. Ask only binding questions, in one numbered round, each with a recommended
   answer that starts from what exists and its material tradeoff. Never ask one
   whose answer depends on another still open; recompute after each reply.
3. Finish with a summary in the user's terms — the need, verified facts and
   bounded premises, each binding decision with its value, any unknown that
   still blocks — then ask for confirmation and stop.
