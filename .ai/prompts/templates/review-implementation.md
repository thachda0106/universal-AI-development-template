# Review Implementation — Output Template

> Use this template when reviewing implemented file changes (git diff, changed files) produced by another agent.
> Every issue must reference specific file and line. Classify each issue by severity.

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

_Missing or incorrect error handling._

### EH-1: [Gap Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [Missing catch, wrong status code, leaked details]
- **Fix**: [How to fix]

## Testing Gaps

_Missing or insufficient tests._

### T-1: [Gap Title]
- **What's missing**: [Test case not covered]
- **Risk**: [What could break undetected]

## Maintainability Issues

_Code that will be hard to maintain._

### M-1: [Issue Title]
- **File**: `path/to/file.ext:line`
- **Problem**: [Magic numbers, unclear naming, excessive complexity]
- **Fix**: [How to improve]

## Required Fixes

_Categorized fix list._

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
