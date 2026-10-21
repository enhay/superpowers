# Frontend Rules

Framework-agnostic additions to [architecture.md](architecture.md). Library
names and folder layout come from each repository.

## Use the established stack

1. A new frontend or page uses the stack the team already standardizes on: the
   component library and its higher layer — layout shell, page container, query
   table, forms — plus the router, request layer, and theme, taken from the
   reference project the plan names. Hand-building any of these while the stack
   provides it is a defect, even when only a lower-level library is installed:
   a layout shell, routing or URL state, table query and pagination, form state
   and validation, a login form. "Minimal" limits the scope, never the stack.
2. For a new project, the plan names the stack and its reference project as a
   binding decision, so installing those packages is approved with the plan
   rather than avoided as a new dependency.

## Structure

3. Dependencies point one way: app shell → pages → reused interactions → reused
   business data → common layer. Modules on the same level do not import each
   other; the common layer holds no business rules.
4. Code starts in the page. Move it out only when all three hold: several places
   use it now, it has its own reason to change, and it does one thing.
5. Other modules import a module through its entry file, never its internal
   files.
6. The backend decides the next action, eligibility, and price and sends them as
   fields. The frontend branches on those fields and never re-derives them from
   raw attributes.
7. API types are generated from the contract, never mirrored by hand.
8. Logic lives in modules testable without rendering; views only display.

## Review signals

| Signal | Rule |
|---|---|
| A hand-built router, layout, query table, or form state beside a stack that provides it | 1 |
| One page file holding the state and requests of several features | 3, 8 |
| Branching on raw attributes to decide the next step or eligibility | 6 |
| Hand-written API types beside a contract | 7 |
| A module imported through an internal file path | 5 |
