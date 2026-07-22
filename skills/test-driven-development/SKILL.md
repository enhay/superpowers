---
name: test-driven-development
description: Use only when the user explicitly requests strict red-green TDD or a project-local rule independently requires it. Do not use merely because work is a feature, bugfix, refactor, security change, business invariant, or public contract.
---

# Test-Driven Development

## Entry condition

Use this workflow only when the user explicitly requests strict red-green TDD or a project-local rule independently requires it. `right-sizing-tests` is not a prerequisite and does not promote work into TDD.

Generic guidance such as "all features and bugfixes require TDD" is not a project-local requirement. If the user has declined new tests, return to the lightest sufficient verification.

## Red-green-refactor

1. Write one failing test for the consequential behavior.
2. Run it and confirm it fails for the missing or incorrect behavior.
3. Implement the minimum change that makes it pass.
4. Run the focused test and relevant existing checks.
5. Refactor only while the checks remain green.

Scope TDD to the high-risk core. Do not require a test for every new function or for unrelated glue.

## Assertions

Anchor assertions to enduring consumer-visible values:

- pure function or selector results;
- persisted or API fields;
- declared state such as ARIA or `data-state`;
- result and permission codes.

Use smoke runs or screenshots for render-only behavior. Do not manufacture text, DOM-shape, existence, count, snapshot, or deletion assertions merely to create a red step.
