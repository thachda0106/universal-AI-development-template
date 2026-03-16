---
description: Perform a comprehensive review of code changes against requirements and architecture.
---

# Workflow: Review Pull Request/Phase (`review-pr.md`)

## Purpose
The purpose of this workflow is to evaluate completed code for quality, architectural compliance, security vulnerabilities, and adherence to project conventions. It acts as the final quality gate before a phase or feature is considered "Done."

## When to Use
Use this workflow during the Review stage of the lifecycle, after tests have passed, or when a human asks the AI to review their Pull Request.

## Inputs
- Code diffs (the changes made in the phase/PR).
- Approved `ARCHITECTURE.md` and `CONVENTIONS.md`.
- Original `{N}-PHASE-DESIGN.md` or PR description.

## Steps
1. **Analyze Purpose:** Understand what the code *intended* to do based on the design doc or PR description.
2. **Check Architecture:** Verify that the code doesn't violate boundaries (e.g., UI directly querying the DB).
3. **Check Quality:** Look for code smells (massive functions, deep nesting, magic strings).
4. **Check Security:** Scan for common vulnerabilities (SQL injection, XSS, exposed secrets).
5. **Check Acceptance:** Ensure all acceptance criteria from the original design were met.
6. **Draft Artifact:** Populate the `.ai/templates/review.md` template (if internal review) or format comments for the PR.
7. **Report:** Present findings to the user.

## Output Artifact
`artifacts/phases/{N}-REVIEW.md` or a structured PR comment.

## Review Requirements
This is a purely analytical workflow. The output is presented to the user for them to consume and act upon.

## Example Usage
```
User: Review the checkout-refactor branch.
AI: Starts Review PR workflow -> Reads diffs -> Notices that the new PaymentController bypasses the PaymentService and calls Stripe directly (Architecture violation) -> Generates REVIEW.md flagging the issue -> Presents to user.
```
