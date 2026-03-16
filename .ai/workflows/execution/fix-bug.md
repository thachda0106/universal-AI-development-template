---
description: Systematically diagnose and repair defects using an evidence-based approach.
---

# Workflow: Fix Bug (`fix-bug.md`)

## Purpose
The purpose of this workflow is to repair defects in the application using a rigorous, scientific approach rather than trial-and-error guessing. It enforces reproducing the bug, identifying the root cause, forming a hypothesis, and testing the fix before committing.

## When to Use
Use this workflow whenever a user reports a bug, log error, UI defect, or failing test that is not part of a planned feature build.

## Inputs
- Bug report (logs, error message, UI symptom, steps to reproduce).
- Current codebase state.

## Steps
1. **Reproduce:** Verify the issue exists by writing a failing test or running a manual check. 
2. **Diagnose:** Trace the execution path. Identify where the expected behavior diverges from the actual behavior.
3. **Hypothesize:** State clearly *why* the bug is occurring, not just *what* is broken.
4. **Plan Fix (Optional for trivial bugs):** Draft a swift, single-task plan for how to patch the issue without breaking surrounding dependencies. Ask for approval if the fix touches critical architecture.
5. **Implement Fix:** Modify the codebase to repair the defect. Add or update tests to prove it stays fixed.
6. **Verify:** Confirm the reproducing test now passes and no immediate regressions occurred. 

## Output Artifact
Code changes + updated tests.

## Review Requirements
The user must approve the fix before it is merged or committed, especially if it alters business logic. For complex bugs, the diagnosis/hypothesis should be approved before coding.

## Example Usage
```
User: The 'Add to Cart' button is throwing a 500 error when the cart is empty.
AI: Starts Fix Bug workflow -> Reads logs showing 'Cannot read properties of undefined (reading length)' in cartService.ts -> Traces state initialization -> Hypothesizes array is null instead of empty -> Updates typing and adds default value -> Adds regression test -> Asks user to review.
```
