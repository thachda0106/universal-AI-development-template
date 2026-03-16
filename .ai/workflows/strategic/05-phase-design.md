---
description: Design the detailed technical approach for a specific phase before breaking it down into tasks.
---

# Workflow: Phase Design (`05-phase-design.md`)

## Purpose
The purpose of this workflow is to bridge the gap between high-level planning and low-level task execution. It captures user preferences, resolves gray areas, defines explicit acceptance criteria, and designs the technical approach for a single phase.

## When to Use
Use this workflow immediately before starting execution on a single phase defined in the master `PLAN.md`.

## Inputs
- Approved master `artifacts/plans/{name}-PLAN.md`.
- Phase number to design.

## Steps
1. **Analyze Phase Scope:** Understand exactly what is in (and out of) scope for this specific phase based on the PLAN.md.
2. **Identify Gray Areas:** Look for ambiguous requirements (e.g., "Implement login" -> Does this mean email/password? OAuth? Magic links?).
3. **Discuss with User:** Ask the user specific questions to resolve these gray areas.
4. **Define Technical Approach:** Draft the detailed design for how this phase will be implemented.
5. **Establish Acceptance Criteria:** Define exactly how we will verify this phase is complete.
6. **Draft Artifact:** Populate the `.ai/templates/phase-design.md` template.
7. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/phases/{N}-PHASE-DESIGN.md`

## Review Requirements
The user MUST approve the `{N}-PHASE-DESIGN.md` artifact before task breakdown begins. This ensures the AI knows *exactly* what to build for this specific phase.

## Example Usage
```
User: Let's start Phase 2 from the master plan.
AI: Starts Phase Design workflow -> Identifies that Phase 2 handles file uploads -> Asks user: "Should we use AWS S3 or local storage?" -> User says S3 -> AI defines the technical approach using S3 -> Generates 2-PHASE-DESIGN.md -> Gets approval.
```
