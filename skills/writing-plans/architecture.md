# Architecture Principles

Language- and framework-agnostic constraints for design, implementation, and
review. A project's own architecture document adds its style choice, its
concrete signals, and where current code deviates; where the two differ, the
project wins.

## Goals

Accept a change by these outcomes, not by whether old code was touched:

- A new variant — a product form, a fee kind, a flow source — lands in its own
  implementation and a registration point; the core and other modules gain no
  check for it.
- A fact — an amount, a state, a relation — has one writer, and every reader
  gets it from that source.
- A module changing its storage or internals forces no change elsewhere.

## Principles

### P1 One owner per fact

A table, a state field, and its invariants belong to one module. Only the owner
writes; others read or request changes through the owner's interface. Before
writing a field, name its owner; if you cannot, settle ownership first. Display
text never identifies a state or an event.

### P2 Dependency direction

Variants depend on the core; the core names no concrete variant — no variant
type code, variant-only service, or variant-only storage. Modules depend on each
other's interfaces and data contracts, never on data access, internal
structures, or storage format. An interface is everything a caller must know —
signature, invariants, ordering, error modes — so changing any of them changes
the contract. When the core must treat a variant differently, add an extension
point per P3 instead of a branch.

Basis: dependency inversion; information hiding.

### P3 The core provides extension points

Variants plug in through points the core declares: a configuration object, a
strategy interface, a registered handler. When none fits, changing the core to
add or widen one is part of the work; never copy the core flow or add a type
check to it. Build a point only for a difference that exists: one
implementation is a hypothetical seam, two make it real.

Before designing, write a difference table against the closest existing flow,
marking each step same, different parameters, different rule, or new step.
Parameters go to configuration, rules to a strategy, new steps to an extension
point; only a different step order or state machine goes to P5. Duplication
beats the wrong abstraction: when the table shows an existing abstraction does
not fit, do not force reuse or pile parameters and conditions onto it.

Prove "existing behavior unaffected" with a regression of the existing path,
never with "existing code untouched".

Basis: open–closed; strategy and template method.

### P4 One concept, one model

A new variant is a type of an existing entity; express the difference with a
type code, a rule, or an extension field. Never build a same-shaped table, a
synonymous enum value, or a parallel service for a concept that already exists:
every consumer would then have to know both. The exception is a different
lifecycle or invariant, and the design then names what the existing model
cannot express.

### P5 When to split a module

Split only when one of these holds: the business language and model differ so
existing concepts do not apply; the state machine differs; a different owner
maintains and releases it on its own cadence. Otherwise it is a variant under
P3 and P4.

Basis: bounded contexts.

### P6 Compose at the caller

Data from several modules is combined by the caller — a service calling each
module, a page composing each module's components — never by attaching one
module's data to another's structure or interface. A component changes for one
reason: when reuse needs a second mode flag, split it into smaller parts each
caller composes.

Apply the deletion test to a layer you suspect: if deleting it makes complexity
vanish, it only forwarded; if complexity reappears across its callers, it earns
its keep.

Basis: single responsibility; composition over configuration.

## Architecture-level changes

Any of these is architecture-level:

- a new module or table, or an enum value of the same kind as existing ones;
- a type branch in a core flow;
- a new cross-module dependency, or a reversed one;
- a new or changed extension point;
- overturning a confirmed design decision.

Its design — the spec, else the plan, else the commit message — answers:

1. Which facts are involved, and which module owns each? (P1)
2. What are the closest existing flow and extension point, and the difference
   table? (P3)
3. Why can the existing model not express each new table, enum value, or
   service? (P4, P5)
4. Through which interfaces do cross-module reads and writes go? (P2, P6)
5. What removes each fork or compatibility path, and which confirmed decision
   does the change overturn?

## Review signals

Each signal needs the author's justification against its principle:

| Signal | Principle |
|---|---|
| A new table or structure shaped like an existing one, or an enum value synonymous with one | P4 |
| Core code naming a concrete variant's type code, service, or storage | P2 |
| A copy of an existing flow's orchestration | P3 |
| A comment or plan saying "align with X", "same as X", or "mirror X" | P3 |
| "Existing behavior unaffected" claimed without an existing-path regression | P3 |
| Reading another module's data access, tables, or storage format | P2 |
| A structure carrying another module's facts in extra non-persisted fields | P6 |
| A component taking a second mode flag, or borrowing another place's configuration by index | P6 |
| Display text used to identify a state or an event | P1 |
| A layer the deletion test shows only forwards | P6 |
