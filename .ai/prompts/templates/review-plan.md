# Review Plan — Output Template

> Use this template when reviewing plan artifacts (SCRATCHPAD.md, PLAN.md, TASKS.md) produced by another agent.
> Every critique must reference specific plan sections. Classify each issue by severity.

## Review Metadata

- **Reviewed by**: review-agent
- **Review date**: _YYYY-MM-DD_
- **Plan version**: _version from PLAN.md if present_
- **Artifacts reviewed**: SCRATCHPAD.md, PLAN.md, TASKS.md

## Summary

_Brief overview of what the plan proposes and overall assessment. 2-3 sentences._

## Critical Issues (MUST_FIX)

_Issues that block implementation. Architecture flaws, missing critical requirements, security holes, data loss risk._

### CI-1: [Issue Title]
- **Reference**: [plan.md section or scratchpad observation]
- **Problem**: [What is wrong]
- **Impact**: [What breaks if not fixed]
- **Required**: [What must change]

_(Add CI-2, CI-3, etc. as needed. Maximum 5 MUST_FIX items.)_

## Architecture Problems

_Design decisions that are suboptimal or risky._

### AP-1: [Issue Title]
- **Reference**: [plan.md section]
- **Concern**: [What is concerning]
- **Suggestion**: [What to consider instead]
- **Severity**: SHOULD_FIX / OPTIONAL

## Missing Requirements

_Requirements that should have been addressed but are not._

### MR-1: [Requirement]
- **What's missing**: [Description]
- **Why it matters**: [Impact of omission]

## Scalability Concerns

_Design choices that may not scale._

### SC-1: [Concern]
- **Reference**: [plan.md section]
- **Problem**: [Why it won't scale]
- **Suggestion**: [Alternative approach]

## Security Concerns

_Security gaps in the plan._

### SEC-1: [Concern]
- **Reference**: [plan.md section]
- **Vulnerability**: [What can be exploited]
- **Required**: [What must be added]

## Data Consistency Concerns

_Issues with transactions, race conditions, eventual consistency._

### DC-1: [Concern]
- **Reference**: [plan.md section]
- **Problem**: [What can go wrong]
- **Required**: [What must be defined]

## Task Breakdown Issues

_Problems with the task list (TASKS.md)._

### T-1: [Issue]
- **Task**: [Task number and title]
- **Problem**: [Missing step, wrong order, vague criteria]

## Suggested Changes

_Numbered list of concrete changes recommended._

1. [Change 1]
2. [Change 2]
3. [Change 3]

## Approval Status

- **APPROVED** — No MUST_FIX items. Ready for implementation.
- **NEEDS_REVISION** — MUST_FIX items present. Plan must be updated before implementation.

**Status**: [APPROVED / NEEDS_REVISION]

**MUST_FIX count**: _
**SHOULD_FIX count**: _
**OPTIONAL count**: _
