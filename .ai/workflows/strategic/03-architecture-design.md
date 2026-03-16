---
description: Design the technical architecture, data models, and system structure.
---

# Workflow: Architecture Design (`03-architecture-design.md`)

## Purpose
The purpose of this workflow is to translate the approved idea and research findings into a concrete system design. It defines components, their responsibilities, data models, and integration points, serving as the blueprint for planning.

## When to Use
Use this workflow for new projects, major feature additions, or when refactoring the core structure of an existing system. For minor surgical changes (like tweaking a CSS file), this workflow may be skipped if the existing architecture is sufficient.

## Inputs
- Approved `{name}-IDEA.md`.
- Approved `{name}-RESEARCH.md` (if applicable).
- Existing `context/PROJECT.md` and `context/CONVENTIONS.md`.

## Steps
1. **Synthesize Inputs:** Review the goals, constraints, and research recommendations.
2. **System Decomposition:** Break the solution down into logical components (e.g., UI, API, Database, External Services).
3. **Define Interfaces:** Map out how these components will talk to each other (API contracts).
4. **Data Modeling:** Define the core state shape, database schema, or entity relationships.
5. **Draft Artifact:** Populate the `.ai/templates/architecture.md` template. Use Mermaid diagrams to visualize interactions.
6. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/architecture/{name}-ARCHITECTURE.md`

## Review Requirements
The user MUST approve the `ARCHITECTURE.md` artifact. This is a critical gate; changes to architecture during implementation are costly, so validation must happen here.

## Example Usage
```
User: Approved the RESEARCH.md for the notification system.
AI: Starts Architecture workflow -> Designs the Event Bus, Notification Worker, and Database Schema schema -> Creates mermaid diagram of workflow -> Generates ARCHITECTURE.md -> Gets approval.
```
