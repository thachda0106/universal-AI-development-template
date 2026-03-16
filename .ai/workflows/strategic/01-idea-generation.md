---
description: Capture, refine, and validate an initial idea before any coding begins.
---

# Workflow: Idea Generation (`01-idea-generation.md`)

## Purpose
The purpose of this workflow is to capture a raw idea, problem statement, or feature request and structure it into a clear, actionable definition. It bounds scope, defines constraints, and acts as the foundational root artifact for all subsequent planning.

## When to Use
Use this workflow at the very beginning of a new project, a new major feature, or when the user proposes a significant directional shift that requires re-grounding.

## Inputs
- User's raw prompt/idea.
- Existing project context (`context/PROJECT.md` if available).

## Steps
1. **Understand the Core Problem:** Have a conversational iteration with the user to fully understand their goals and the 'why' behind the idea. Do not write code.
2. **Identify Constraints & Boundaries:** Extract technical, business, and timeline constraints.
3. **Bound the Scope:** Explicitly define what is going to be built (v1) and what is out of scope (non-goals).
4. **Assess Feasibility:** Do a quick mental check for glaring technical impossibilities.
5. **Draft Artifact:** Populate the `.ai/templates/idea.md` template with findings.
6. **Request Approval:** Present the artifact to the user for sign-off.

## Output Artifact
`artifacts/ideas/{name}-IDEA.md`

## Review Requirements
The user MUST approve the `IDEA.md` artifact before moving to the Research or Architecture stages. The approval acts as the first gate.

## Example Usage
```
User: I want to add a dark mode toggle to the dashboard.
AI: Starts Idea Generation workflow -> Asks clarifying questions (e.g., Should it follow OS preferences? Is there a specific palette?) -> Generates IDEA.md -> Gets approval.
```
