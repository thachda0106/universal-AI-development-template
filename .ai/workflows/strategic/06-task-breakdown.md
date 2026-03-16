---
description: Decompose an approved phase design into atomic, executable tasks and XML plans.
---

# Workflow: Task Breakdown (`06-task-breakdown.md`)

## Purpose
The purpose of this workflow is to translate the approved phase design into actionable, file-level instructions. It creates the explicit instructions the executing agent will follow, organized into sequential waves for parallelization.

## When to Use
Use this workflow immediately after a Phase Design is approved.

## Inputs
- Approved `artifacts/phases/{N}-PHASE-DESIGN.md`.
- Read access to the current codebase (to identify existing files vs. new files needed).

## Steps
1. **Review Phase Design:** Internalize the technical approach and acceptance criteria.
2. **Decompose into Tasks:** Break the work down into atomic units (e.g., "Create User Model," "Add API Controller," "Implement UI Component").
3. **Identify Files:** For each task, explicitly list the exact file paths to be created, modified, or deleted.
4. **Define Verification:** Write a specific verification command or step for each task (e.g., `npm run lint src/api/user.ts`).
5. **Group into Waves:** Group tasks that can be done in parallel into the same wave. Dependent tasks must go into sequential waves.
6. **Draft Artifact:** Populate the `.ai/templates/tasks.md` template using the XML `<task>` structure.
7. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/phases/{N}-TASKS.md`

## Review Requirements
The user MUST approve the `{N}-TASKS.md` artifact. This is the final gate before actual code generation begins.

## Example Usage
```
User: Approved the 2-PHASE-DESIGN.md for the new S3 uploader.
AI: Starts Task Breakdown workflow -> Creates Wave 1 tasks: Setup AWS SDK, define interface -> Creates Wave 2 tasks: Implement service class, add tests -> Generates 2-TASKS.md -> Gets approval.
```
