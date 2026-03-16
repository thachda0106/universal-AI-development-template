---
description: Master reference for the 10-stage AI-first development lifecycle pipeline.
---

# The AI-First Development Lifecycle (`lifecycle.md`)

This document defines the overarching 10-stage pipeline for this repository. All AI assistants operating within this project MUST adhere strictly to these ordered stages.

## Core Philosophy

This lifecycle is built on **Spec-Driven, Context-Engineered Development**. AI assistants perform best when given precise, bounded contexts rather than open-ended queries in massive chat windows.

1. **No coding without a plan:** The `IMPLEMENTATION` stage cannot begin until an approved `TASKS.md` artifact exists.
2. **Approval Gates are absolute:** The human user MUST explicitly approve stage transitions.
3. **Artifacts are the Source of Truth:** Every decision, constraint, and execution log lives in versioned markdown files in the `.ai/artifacts/` directory.

---

## The 10 Stages

### Strategic Stages (The "WHAT" and "HOW")
1. **IDEATION** (`01-idea-generation.md`)
   - **Goal:** Define the problem, goals, and out-of-scope boundaries.
   - **Artifact:** `artifacts/ideas/{name}-IDEA.md`
2. **RESEARCH** (`02-research.md`)
   - **Goal:** Investigate domain, APIs, and libraries. Compare approaches.
   - **Artifact:** `artifacts/research/{name}-RESEARCH.md`
3. **ARCHITECTURE** (`03-architecture-design.md`)
   - **Goal:** Define system components, data models, and integration points.
   - **Artifact:** `artifacts/architecture/{name}-ARCHITECTURE.md`
4. **PLANNING** (`04-planning.md`)
   - **Goal:** Define the roadmap, dividing work into coarse Milestones and Phases.
   - **Artifact:** `artifacts/plans/{name}-PLAN.md`
5. **PHASE DESIGN** (`05-phase-design.md`)
   - **Goal:** Define the specific technical approach and acceptance criteria for *one* phase.
   - **Artifact:** `artifacts/phases/{N}-PHASE-DESIGN.md`
6. **TASK BREAKDOWN** (`06-task-breakdown.md`)
   - **Goal:** Decompose the Phase Design into execution waves of atomic tasks with verification steps.
   - **Artifact:** `artifacts/phases/{N}-TASKS.md`

### Execution Stages (The "DO")
7. **IMPLEMENTATION** (`implement-task.md`)
   - **Goal:** Write the code exactly as specified in the TASKS artifact. Commit frequently.
   - **Artifact:** `artifacts/phases/{N}-IMPLEMENTATION-LOG.md`
8. **TESTING** (`add-tests.md`)
   - **Goal:** Verify logic via automated tests and manual acceptance criteria checks.
   - **Artifact:** `artifacts/phases/{N}-TEST-RESULTS.md`
9. **REVIEW** (`review-pr.md`)
   - **Goal:** Validate code against architecture, conventions, and security best practices.
   - **Artifact:** `artifacts/phases/{N}-REVIEW.md`
10. **OPTIMIZATION** (`optimize-performance.md`, `refactor.md`)
    - **Goal:** Clean up tech debt, improve performance metrics, and refine code structure.
    - **Artifact:** `artifacts/phases/{N}-OPTIMIZATION.md`

---

## Directory Architecture

```
.ai/
├── artifacts/          # Project-specific generated artifacts (ideas, plans, etc.)
├── context/            # Global context (PROJECT.md, CONVENTIONS.md)
├── templates/          # Standardized markdown templates for artifacts
└── workflows/          # The defined instructions for the AI
    ├── strategic/      # Workflows 01-06
    └── execution/      # Workflows 07-10 plus bug-fixing
```

## The Golden Rule
If the AI encounters a problem during `IMPLEMENTATION` that requires a change in scope, architecture, or dependencies, it MUST halt execution and escalate backward in the pipeline (e.g., return to the `PHASE DESIGN` or `ARCHITECTURE` stage) and secure human approval before proceeding.
