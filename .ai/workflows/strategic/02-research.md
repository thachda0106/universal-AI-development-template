---
description: Investigate the domain, existing solutions, libraries, and patterns before architecture.
---

# Workflow: Research (`02-research.md`)

## Purpose
The purpose of this workflow is to investigate the technical landscape, compare available libraries/frameworks, identify known design patterns, and gather evidence to support architectural decisions. It prevents "guessing" by forcing an explicit discovery phase.

## When to Use
Use this workflow after an Idea is approved, especially when the implementation requires using unfamiliar APIs, choosing between multiple third-party libraries, or solving a complex domain problem (e.g., finding the best way to implement real-time websockets).

## Inputs
- Approved `{name}-IDEA.md`.
- Read access to the internet/documentation (if available).

## Steps
1. **Analyze the Idea:** Review the goals and constraints in the approved IDEA.md.
2. **Identify Unknowns:** List the technical areas that require investigation.
3. **Conduct Investigation:** Research available approaches, libraries, and best practices. Compare pros and cons.
4. **Formulate Recommendations:** Based on constraints, recommend a specific technical direction.
5. **Draft Artifact:** Populate the `.ai/templates/research.md` template with findings, citations, and recommendations.
6. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/research/{name}-RESEARCH.md`

## Review Requirements
The user MUST approve the `RESEARCH.md` artifact before moving to Architecture or Planning. They may request deeper investigation into specific alternatives.

## Example Usage
```
User: Approved the IDEA.md for the new auth system.
AI: Starts Research workflow -> Investigates JWT vs Session cookies for this specific stack -> Compares Passport.js vs Auth.js -> Generates RESEARCH.md -> Gets approval on using Auth.js with JWTs.
```
