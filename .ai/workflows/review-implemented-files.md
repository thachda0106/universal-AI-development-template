---
description: Review implemented file changes (git diff, changed files) produced by any AI agent — outputs structured critique as review-implementation.md
agent: review-agent
---

# Review Implemented Files

Review code changes produced by another AI agent. Act as a strict Principal Engineer / Security Reviewer. Find bugs, security vulnerabilities, architecture violations, and correctness issues in the implementation.

Execute all steps in sequence without stopping. Output `review-implementation.md` when complete.

---

## STEP 1 — LOAD CONTEXT

1. Read project context files (`context/PROJECT.md`, `context/CONVENTIONS.md`, `context/BOUNDARIES.md`)
2. Gather the changes to review:
   - Run `git diff` to see uncommitted changes
   - Run `git diff HEAD~1` or `git log --oneline -5` to see recent commits
   - Read the full content of all changed files
3. If a plan exists (`PLAN.md`, `TASKS.md`), read it to understand intended behavior

---

## STEP 2 — IMPLEMENTATION REVIEW

### 1. Correctness Analysis
- Does the code match the plan (if plan exists)?
- Are there logic errors?
- Are there off-by-one errors, null pointer risks, type mismatches?
- Are edge cases handled (empty arrays, null values, boundary conditions)?

### 2. Bug Detection
- Are there race conditions?
- Are there resource leaks (unclosed connections, missing cleanup)?
- Are there infinite loops or missing termination conditions?
- Are there unhandled promise rejections or missing error boundaries?

### 3. Security Review
- Is user input validated and sanitized?
- Are there SQL injection, XSS, or command injection risks?
- Are secrets/credentials exposed in code or logs?
- Are authentication/authorization checks present where needed?
- Are file paths validated (path traversal prevention)?

### 4. Architecture Compliance
- Does code follow existing patterns in the codebase?
- Are import boundaries respected?
- Is the correct layer used (service vs controller vs repository)?
- Are there circular dependencies introduced?

### 5. Performance Review
- Are there N+1 query patterns?
- Are there missing database indexes for new queries?
- Are large datasets loaded into memory unnecessarily?
- Are there unnecessary re-renders or computations?

### 6. Error Handling
- Are exceptions caught at the right level?
- Are error messages user-safe (no internal details leaked)?
- Are HTTP status codes correct?
- Are database transactions rolled back on error?

### 7. Testing Assessment
- Do tests exist for the changes?
- Are success and failure paths tested?
- Are edge cases covered?
- Are mocks used correctly?

---

## STEP 3 — OUTPUT

Generate `review-implementation.md` with the following structure. Every issue must reference specific file and line. Classify each issue by severity.

### Output Structure

```markdown
## Review Metadata

- **Reviewed by**: review-agent
- **Review date**: _YYYY-MM-DD_
- **Commit(s) reviewed**: _git commit hash or range_
- **Files changed**: _list of changed files_
- **Plan reference**: _PLAN.md version if available_

## Summary

_Brief overview of what was implemented and overall assessment. 2-3 sentences._

## Correctness Issues

_Code that is logically wrong or doesn't match the plan._

### CO-1: [Issue Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [What is wrong]
- **Impact**: [What breaks]
- **Fix**: [How to fix]

## Bugs

_Actual bugs that will cause failures._

### B-1: [Bug Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [Bug description]
- **Scenario**: [How to reproduce / trigger]
- **Fix**: [How to fix]

## Architecture Violations

_Code that breaks project patterns or architectural rules._

### AV-1: [Violation Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [What rule is violated]
- **Expected**: [What should be done instead]
- **Fix**: [How to fix]

## Security Issues

_Vulnerabilities in the implementation._

### S-1: [Issue Title]
- **File**: `path/to/file.ext:line`
- **Vulnerability**: [What can be exploited]
- **Impact**: [What an attacker can do]
- **Fix**: [How to fix]

## Performance Issues

_Code that will cause performance problems._

### P-1: [Issue Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [N+1 query, missing index, unnecessary allocation]
- **Impact**: [Performance degradation]
- **Fix**: [How to fix]

## Error Handling Gaps

### EH-1: [Gap Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [Missing catch, wrong status code, leaked details]
- **Fix**: [How to fix]

## Testing Gaps

### T-1: [Gap Title]
- **What's missing**: [Test case not covered]
- **Risk**: [What could break undetected]

## Maintainability Issues

### M-1: [Issue Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [Magic numbers, unclear naming, excessive complexity]
- **Fix**: [How to improve]

## Required Fixes

### MUST FIX (blocks merge)
1. [Reference to issue above]
2. [Reference to issue above]

### SHOULD FIX (follow-up recommended)
1. [Reference to issue above]

### OPTIONAL (nice to have)
1. [Reference to issue above]

## Approval Status

- **APPROVED** — No MUST_FIX items. Ready for merge.
- **APPROVED_WITH_COMMENTS** — No MUST_FIX but SHOULD_FIX items exist. Can merge with follow-up.
- **CHANGES_REQUESTED** — MUST_FIX items present. Must fix before merge.

**Status**: [APPROVED / APPROVED_WITH_COMMENTS / CHANGES_REQUESTED]
**MUST_FIX count**: _
**SHOULD_FIX count**: _
**OPTIONAL count**: _
```

**Severity Classification:**
- **MUST_FIX**: Bugs, security vulnerabilities, data corruption risk, correctness errors
- **SHOULD_FIX**: Architecture violations, performance issues, missing error handling
- **OPTIONAL**: Style improvements, test coverage suggestions, maintainability concerns

Present the summary to the human with the approval status and issue counts.
