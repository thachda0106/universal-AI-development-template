---
description: End-to-end design-to-code pipeline — from OpenAPI spec through UX design, component architecture, code generation, and testing
agent: feature-builder
---

# Design-to-Code Pipeline

Transform an OpenAPI specification into a fully tested UI through a gated design-to-development pipeline. Each stage produces a concrete, reviewable artifact.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — DISCOVERY (Tech Stack & Setup)

**No design or code in this phase. Gather inputs and validate prerequisites only.**

1. Ask the user for the **OpenAPI spec location** (file path, URL, or inline). If none exists, ask if they want to create one first or proceed with a manual feature spec.

2. Present the tech stack selection table below. User confirms defaults or selects alternatives:

| Stage | Default Tool | Alternatives |
|-------|-------------|-------------|
| API Documentation | Swagger / Redoc / Stoplight | Scalar, Stoplight Elements |
| Feature Mapping | Manual (agent-assisted) | — |
| UX Flow | Mermaid + Excalidraw | FigJam, Lucidchart, draw.io |
| Wireframe | Penpot | Figma, Balsamiq, Excalidraw |
| UI Design | Penpot / Figma | Sketch, Adobe XD |
| Design Review | Manual (agent-assisted) | — |
| Component Contract | Manual (agent-generated) | — |
| Storybook | Storybook 8 | Ladle, Histoire |
| Component Library | React 18+ | Vue, Svelte, Solid |
| API Hooks | TanStack Query v5 + OpenAPI Generator | RTK Query, SWR |
| Integration Tests | Vitest + React Testing Library | Jest + RTL |
| E2E Tests | Playwright | Cypress, Selenium |

3. Run prerequisite checks and install missing tools. For each selected tool, execute setup:

```bash
# Storybook
npx storybook@latest init --type react
npm run storybook  # verify: starts on localhost:6006

# Playwright
npm init playwright@latest
npx playwright test  # verify: runs example test

# OpenAPI Generator (if selected)
npm install -D @openapitools/openapi-generator-cli
npx openapi-generator-cli version  # verify

# TanStack Query
npm install @tanstack/react-query
```

4. Validate the OpenAPI spec (if provided):
   - Parse and check for structural validity
   - Verify required fields (paths, methods, schemas)
   - Report errors or missing sections for human resolution

5. Read project context (`context/PROJECT.md`, `context/CONVENTIONS.md`, `context/BOUNDARIES.md`).

6. Write findings into `SCRATCHPAD.md`:
   - Selected tech stack per stage
   - OpenAPI spec validation results
   - Prerequisite check results
   - Any blockers or missing dependencies

**Output**: `SCRATCHPAD.md`

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Discovery) complete. Tech stack selected, prerequisites validated.
Please review SCRATCHPAD.md.
Reply APPROVE to continue to the Spec & Map phase, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — SPEC & MAP (Requirements)

**Scratchpad must be APPROVED. No code in this phase.**

### Stage 1 — API Documentation
- Generate interactive API docs from the OpenAPI spec using the selected documentation tool.
- If using Swagger: `npx swagger-ui-dist` or serve via a local container.
- If using Redoc: `npx @redocly/cli build-docs <spec> -o api-docs.html`.
- Verify all endpoints, request/response schemas, and auth methods are documented.

**Artifact**: Rendered API docs (M)

### Stage 2 — Feature Map
Deploy `requirements-analyst` sub-agent. From the API spec:
- Group endpoints into logical feature areas (e.g., auth, users, products, orders).
- Map each feature area to the UI components it will need.
- Identify cross-cutting concerns (auth, error handling, loading states).
- Document in a feature map table.

**Artifact**: Feature map document (M)

### Stage 3 — User Stories + Acceptance Criteria
Deploy `requirements-analyst` sub-agent. For each feature area:
- Write user stories in "As a [role], I want [goal], so that [reason]" format.
- Define acceptance criteria using Given/When/Then.
- Prioritize: P1 (MVP), P2 (enhancement), P3 (nice-to-have).
- Review for completeness against all API endpoints.

**Artifact**: Requirements document with user stories and AC (M)

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Spec & Map) complete. Requirements documented.
Please review the feature map and user stories.
Reply APPROVE to continue to UX & Design, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — UX & DESIGN

**Spec must be APPROVED. No code in this phase.**

### Stage 4 — UX Flow (Optional)
Deploy `frontend-architect` sub-agent:
- Create flow diagrams showing user navigation through features.
- Use Mermaid for text-based diagrams checked into the repo.
- Use Excalidraw (or selected alternative) for visual diagrams.
- Cover: happy path, empty states, error states, loading states.

**Artifact**: UX flow diagrams in `.mmd` and `.excalidraw` formats (O)

### Stage 5 — Wireframe (Optional)
Deploy `frontend-architect` sub-agent:
- Create low-fidelity wireframes for each page/screen.
- Use Penpot (or selected alternative).
- Focus on layout, information hierarchy, and navigation — not visual design.
- Map wireframes back to user stories to ensure coverage.

**Artifact**: Wireframes in Penpot/Figma (O)

### Stage 6 — UI Design (Optional)
Deploy `frontend-architect` sub-agent:
- Produce high-fidelity UI mockups from wireframes.
- Apply design tokens (colors, typography, spacing).
- Ensure responsive breakpoints are designed (mobile, tablet, desktop).
- Verify WCAG 2.1 AA contrast ratios.

**Artifact**: High-fidelity UI designs (O)

### Stage 7 — Design Review (Optional)
- Review designs against user stories and acceptance criteria.
- Check for missing states (loading, empty, error, edge cases).
- Validate accessibility (keyboard navigation, screen reader flow).
- Document review findings. Iterate on Stages 5-6 if needed.

**Artifact**: Design review sign-off document (O)

### 🛑 HARD STOP — APPROVAL GATE 3

```
Say: "Phase 3 (UX & Design) complete. Designs reviewed.
Please review the UX flows, wireframes, and UI designs.
Reply APPROVE to continue to Component Architecture, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 4 — COMPONENT ARCHITECTURE

**Design must be APPROVED. No page code in this phase — components only.**

### Stage 8 — Component Contract
Deploy `frontend-architect` sub-agent:
- From the approved UI designs and feature map, extract every reusable UI element.
- For each component, define:
  - **Props** — name, type, required/optional, default value
  - **States** — default, hover, focus, active, disabled, loading, error, empty
  - **Events** — onClick, onChange, onSubmit, etc.
  - **Slots/Children** — where composable content goes
  - **Accessibility** — ARIA roles, labels, keyboard interactions
- Cross-reference components against user stories to ensure all UI needs are covered.
- Use the `validate-architecture` skill to verify component boundaries and responsibilities.

**Artifact**: Component contract document — one table per component (M)

### Stage 9 — Storybook Setup
```bash
# Initialize if not done in Phase 1
npx storybook@latest init --type react
```
- Configure Storybook to match the project's path aliases and styling setup.
- Verify Storybook starts: `npm run storybook` → localhost:6006.
- Set up essential addons: controls, actions, viewport, a11y.

**Artifact**: Storybook configuration and working instance (M)

### Stage 10 — React Component Library
Deploy `frontend-architect` sub-agent. For each component in the contract:
1. Create the component file: `src/components/<ComponentName>/<ComponentName>.tsx`
2. Create the Storybook story: `src/components/<ComponentName>/<ComponentName>.stories.tsx`
3. Create the component test: `src/components/<ComponentName>/<ComponentName>.test.tsx`
4. Implement all states defined in the contract.
5. Export from a barrel file: `src/components/index.ts`

Implementation rules:
- Use the framework selected in Phase 1 (React 18+ by default).
- Apply project path aliases for imports.
- Include PropTypes or TypeScript types for all props.
- Components must handle: loading, empty, error, and edge-case states.
- All interactive elements must be keyboard-accessible.

**Artifact**: Component library with stories and tests (M)

### 🛑 HARD STOP — APPROVAL GATE 4

```
Say: "Phase 4 (Component Architecture) complete. Component library built with Storybook stories.
Review the Storybook at localhost:6006.
Reply APPROVE to continue to Pages & Integration, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 5 — PAGES & INTEGRATION

**Component library must be APPROVED.**

### Stage 11 — Page Assembly
Deploy `frontend-architect` sub-agent:
- Compose components from the library into full pages.
- Pages go in `src/pages/` with one folder per route.
- Each page contains: layout composition, data fetching wiring (placeholder), routing setup.
- Cover all states: loading skeleton, success, empty, error boundary.

**Artifact**: Page components (M)

### Stage 12 — API Hooks
- Run OpenAPI Generator to produce typed API client:
  ```bash
  npx openapi-generator-cli generate -i <spec> -g typescript-fetch -o src/api/generated
  ```
- Install TanStack Query and create custom hooks wrapping generated API calls:
  ```bash
  npm install @tanstack/react-query
  ```
- For each API endpoint, create a hook in `src/hooks/` following the pattern `use<EntityName>`:
  - `useQuery` for GET requests
  - `useMutation` for POST/PUT/PATCH/DELETE
  - Handle loading, error, and success states
  - Configure stale time, retry, and cache invalidation
- Wire hooks into page components (replace placeholders from Stage 11).

**Artifact**: Typed API hooks + generated client (M)

### 🛑 HARD STOP — APPROVAL GATE 5

```
Say: "Phase 5 (Pages & Integration) complete. Pages assembled and wired to API hooks.
Reply APPROVE to continue to Testing, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 6 — TESTING

**Pages and hooks must be APPROVED.**

### Stage 13 — Integration Tests
Deploy `test-engineer` sub-agent:
- Write integration tests for each page, verifying:
  - Page renders with mocked API responses (loading → success).
  - Error state displays correctly on API failure.
  - Empty state renders when API returns no data.
  - User interactions trigger expected API calls.
- Use `Vitest` + `React Testing Library` (or Jest+RTL if selected):
  ```bash
  npm install -D vitest @testing-library/react @testing-library/jest-dom msw
  ```
- Configure MSW (Mock Service Worker) to intercept API calls:
  ```bash
  npx msw init public/
  ```

**Artifact**: Integration test suite (M)

### Stage 13b — E2E Tests
Deploy `test-engineer` sub-agent:
- Write Playwright E2E tests covering critical user flows:
  - Happy path: user completes primary task end-to-end.
  - Error path: API failure recovery.
  - Accessibility: keyboard-only navigation through flow.
- Cover all user stories from Phase 2 with at least one E2E test each.
- Use the `verify-bug-regression` skill to confirm tests pass.

**Artifact**: E2E test suite (M)

### Final Validation
```bash
# Run all tests
npx vitest run
npx playwright test

# Lint and type check
npm run lint
npx tsc --noEmit
```

- Verify all tests pass.
- Verify no TypeScript errors.
- Verify integration tests and E2E tests cover all mandatory stages.
- Run `bash .ai/scripts/validate-template.sh` if workflow files were modified.

---

## Pipeline Summary

```
OpenAPI ──► Docs ──► Feature Map ──► User Stories + AC
                                            │
                          ┌─────────────────┘
                          ▼
                      UX Flow ──► Wireframe ──► UI Design ──► Design Review
                                                                      │
                          ┌───────────────────────────────────────────┘
                          ▼
                  Component Contract ──► Storybook ──► Component Library
                                                                      │
                          ┌───────────────────────────────────────────┘
                          ▼
                        Pages ──► API Hooks (TanStack Query + OpenAPI Gen)
                                                                      │
                          ┌───────────────────────────────────────────┘
                          ▼
                  Integration Tests ──► E2E Tests (Playwright)
```

| Stage | Artifact | Required | Skip Condition |
|-------|----------|----------|----------------|
| 1 | API Documentation | M | — |
| 2 | Feature Map | M | — |
| 3 | User Stories + AC | M | — |
| 4 | UX Flow | O | Existing flows available |
| 5 | Wireframe | O | Existing wireframes available |
| 6 | UI Design | O | Existing designs available |
| 7 | Design Review | O | Skipped if no new designs |
| 8 | Component Contract | M | — |
| 9 | Storybook | M | — |
| 10 | Component Library | M | — |
| 11 | Pages | M | — |
| 12 | API Hooks | M | — |
| 13 | Tests | M | — |
