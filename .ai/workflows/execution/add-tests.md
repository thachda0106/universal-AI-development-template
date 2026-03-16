---
description: Generate comprehensive tests for existing code or planned features.
---

# Workflow: Add Tests (`add-tests.md`)

## Purpose
The purpose of this workflow is to systematically increase test coverage, ensuring that edge cases, happy paths, and error states are codified into automated checks.

## When to Use
Use this workflow immediately after the Implementation stage, when fixing a bug (to prove it's fixed), or when encountering legacy code with poor coverage.

## Inputs
- Target file(s) or module.
- Testing framework context (e.g., Jest, Vitest, Playwright).

## Steps
1. **Analyze Target Code:** Understand the inputs, outputs, side-effects, and dependencies of the code being tested.
2. **Identify Test Scenarios:** List out the paths:
   - Happy paths (standard expected usage)
   - Edge cases (boundary values, empty arrays)
   - Error paths (network failures, invalid inputs)
3. **Setup Mocks:** Identify what needs to be mocked (e.g., DB calls, third-party APIs) and set them up.
4. **Implement Tests:** Write the test cases.
5. **Verify:** Run the tests to ensure they execute correctly. Use test coverage flags if available.

## Output Artifact
New or updated test files (`*.test.ts`, `*.spec.ts`).

## Review Requirements
No explicit approval is required unless the testing framework itself needs to be changed or introduced.

## Example Usage
```
User: We need tests for the new PaymentProcessor class.
AI: Starts Add Tests workflow -> Analyzes dependencies (Stripe API) -> Sets up Stripe mocks -> Writes happy path test, declined card test, and network timeout test -> Runs suite to ensure passing.
```
