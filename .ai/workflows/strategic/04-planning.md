---
description: Create the high-level implementation roadmap, establishing milestones and phases.
---

# Workflow: Planning (`04-planning.md`)

## Purpose
The purpose of this workflow is to map out the execution strategy. It breaks down the full architectural vision into manageable milestones and phases, ensuring logical sequencing and dependency management without getting lost in file-level details.

## When to Use
Use this workflow immediately after an Architecture Design is approved, or when a major project needs to be structurally organized before execution begins.

## Inputs
- Approved `{name}-ARCHITECTURE.md` (or detailed `IDEA.md` for simpler projects).
- Existing `context/PROJECT.md` and `context/CONVENTIONS.md`.

## Steps
1. **Review Architecture:** Understand the scope and components from the architecture document.
2. **Define Milestones:** Group logical chunks of work into milestones (e.g., "Milestone 1: Core Foundation," "Milestone 2: User Authentication").
3. **Define Phases:** Break milestones into sequential, deliverable phases. Each phase should represent a meaningful increment of value.
4. **Map Dependencies:** Ensure phases are ordered logically (e.g., database before API route).
5. **Draft Artifact:** Populate the `.ai/templates/plan.md` template.
6. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/plans/{name}-PLAN.md`

## Review Requirements
The user MUST approve the `PLAN.md` artifact. This locks in the high-level roadmap and determines the order of execution.

## Example Usage
```
User: Approved the ARCHITECTURE.md for the new e-commerce checkout.
AI: Starts Planning workflow -> Creates Milestone 1: Cart API, Milestone 2: Payment Integration, Milestone 3: UI -> Breaks them into 7 sequential phases -> Generates PLAN.md -> Gets approval.
```
