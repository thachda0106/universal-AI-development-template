# Codex Agent Instructions

This repository contains configuration, skills, subagents, and workflows for the Codex AI agent tool.

## Project Overview

- **Name**: codex-config
- **Description**: Codex AI agent configuration — skills, workflows, subagents, rules, and MCP server configs
- **Purpose**: Provide a reusable configuration layer for Codex to extend its capabilities

## Repository Structure

```
├── config.toml            ← Project-scoped config (MCP servers, agents, sandbox)
├── AGENTS.md              ← Custom instructions (this file)
├── agents/                ← Custom subagent definitions (TOML, 7 files)
├── skills/                ← Agent skills for Codex runtime (33 skills)
└── README.md              ← Install guide for global deployment
```

---

# Coding Conventions

## Communication Style

- Respond in a purely technical, objective manner
- No emotional language, pleasantries, or personal opinions
- Focus exclusively on technical accuracy and implementation details

## Type Safety

- Use strict typing — avoid `any` without justification
- Leverage type inference where types are obvious
- Extract shared types to a common location if reused across modules

## Testing Standards

- Tests verify behavior, not implementation details
- Mock external dependencies (database, HTTP, file system)
- Arrange-Act-Assert pattern
- One behavior per test case
- Descriptive test names that explain the scenario

---

# Boundaries and Safety Invariants

## Scope Rules

- Do NOT modify code outside the scope of the current task
- Do NOT refactor unrelated code while fixing bugs
- Do NOT optimize unless explicitly requested
- If > 3 files need changes for a single task, verify scope is appropriate
- Each file is written once per task — re-read before re-writing

## Forbidden Actions

### Destructive Operations
- Never execute `rm -rf` or equivalent destructive commands
- Never run `git push` or `git reset --hard` without explicit approval
- Never modify build output directories (`dist/`, `build/`, `out/`)
- Never modify `node_modules/` or dependency lock files directly

### Sensitive Data
- Never read `.env` files or environment variable files
- Never read secrets, credentials, or API keys
- Never read Terraform state or infrastructure secrets
- Never expose sensitive data in code, logs, or documentation

### Code Integrity
- Never mix different editing strategies on the same file
- Never wipe entire files — edit section by section
- If a file changes externally, re-read before writing
- When multiple files are related, read all first, then write one by one

### Skipping Approval Gates
- **Never skip a human approval gate** — this is a critical safety violation
- Never generate SCRATCHPAD and PLAN in the same response
- Never generate PLAN and TASKS in the same response
- Never write implementation code before TASKS are approved
- Never run all workflow phases in a single execution
- Never assume approval — wait for explicit user confirmation

## MCP / External Tool Usage Rules

### Documentation Tools (e.g., Context7)
- Use for external library documentation only
- Do NOT use as a substitute for reading project code
- Do NOT rely on assumed knowledge — fetch latest docs when uncertain

### Code Analysis Tools (e.g., Serena, language servers)
- Use for symbol-level and semantic code analysis
- Do NOT use for broad text searches — use grep/search instead
- Do NOT use for file listing — use directory tools instead

### Repository Tools (e.g., GitHub)
- Use for PR management, code review, issue tracking
- Authentication must be configured separately per developer
- Never commit secrets through repository tools

## Human Review Checkpoints

Every checkpoint below is a **HARD STOP**. The AI must pause and wait for explicit human approval.

| # | Checkpoint | Output Artifact | AI Must Say |
|---|-----------|----------------|-------------|
| 1 | After SCRATCHPAD phase | `SCRATCHPAD.md` | "Please review the scratchpad. Reply APPROVE to continue." |
| 2 | After PLAN phase | `PLAN.md` | "Please review the plan. Reply APPROVE to continue." |
| 3 | After TASKS phase | `TASKS.md` | "Please review the tasks. Reply APPROVE to continue." |
| 4 | After IMPLEMENTATION | Completed code | "Implementation complete. Please review before final testing." |

Additional review triggers:
- Architecture decisions: require explicit approval
- Breaking changes: require explicit approval
- New dependencies: verify existing alternatives first
- If a decision changes during execution: update scratchpad and STOP for re-approval

---

# Operating Model

Follow the **Scratchpad → Plan → Tasks → Execute → Verify** lifecycle for all non-trivial tasks.

**Every phase requires explicit human approval before proceeding to the next.**

1. **Scratchpad**: Analyze the task, define scope, identify invariants. Output `SCRATCHPAD.md`.
   → **STOP. Ask for approval.**
2. **Plan**: Define architecture, modules, risks, edge cases. Output `PLAN.md`.
   → **STOP. Ask for approval.**
3. **Tasks**: Break plan into ordered implementation steps. Output `TASKS.md`.
   → **STOP. Ask for approval.**
4. **Execute**: Implement tasks one at a time, strictly following the approved plan.
5. **Verify**: Run tests, lint, type checks. Confirm behavior matches the plan.
6. **Reflect**: Review execution quality. Capture learnings and suggest workflow improvements.

## Approval Gate Enforcement

These rules are **non-negotiable**. Violating them is a critical failure.

- You must **STOP and wait for explicit human approval** after each phase.
- You must **NEVER** proceed to the next phase without the user saying "APPROVE" or equivalent.
- You must **NEVER** generate SCRATCHPAD + PLAN in the same response.
- You must **NEVER** generate PLAN + TASKS in the same response.
- You must **NEVER** write implementation code before TASKS are approved.
- You must **NEVER** run all phases in a single execution.

**When stopping for approval, say exactly:**

> "Phase [N] complete. Please review [ARTIFACT].
> Reply **APPROVE** to continue to the next phase, or provide feedback."

## Decision Framework

- **Before coding**: Do we have an approved scratchpad? An approved plan? Approved tasks?
- **If any answer is NO**: STOP. Do not proceed.
- **Scratchpad is the source of truth.** Plans explain HOW. Tasks define WHAT. Code is the last step.

## Quality Standards

- Match existing code style exactly
- Minimal changes — fix what is asked, nothing more
- Test all changes before declaring done
- Never introduce scope creep

## Security Rules

Never read: `.env`, `.env.*`, `**/terraform.tfvars`, `**/terraform.tfvars.*`, `**/terraform.tfstate`, `**/terraform.tfstate.*`, `/secrets/**`, `/config/credentials.json`
Never execute: `rm -rf`, `rm-rf`, `git push`, `git reset --hard`
Never edit: `/dist/**`, `/node_modules/**`
Never expose secrets, credentials, or API keys in code, logs, or documentation

## Available Workflows

When asked to perform a task below, load the corresponding skill (from `$skills/<name>/SKILL.md`) and follow it step by step:

- **add-api-integration**: Add integration with an external API or service (agent: feature-builder)
- **add-tests**: Generate comprehensive tests following project testing standards (agent: test-engineer)
- **ai-workflow**: Master AI-assisted development lifecycle — plan, review, execute, verify
- **build-large-system**: BigTech-level System Development Lifecycle — 30 phases from idea to production to evolution (agent: feature-builder)
- **build-large-system-phases-01-10**: Phases 01–10: Discovery & Requirements → Domain & Architecture
- **build-large-system-phases-11-20**: Phases 11–20: Technology Selection → Platform & Infrastructure → Service Development → Observability
- **build-large-system-phases-21-30**: Phases 21–30: Hardening → Launch → Operations → Evolution
- **build-minimum-system**: Minimum Build System Workflow — 9 phases from idea to production, compressed from the 30-phase lifecycle (agent: feature-builder)
- **create-feature**: Create a new feature module following project architecture and conventions (agent: feature-builder)
- **daily-cognitive-scan**: Scan recent thinking for cognitive distortions and biases (agent: life-engineer)
- **daily-emotional-observability**: Emotional state check — collect emotional metrics, detect anomalies, identify triggers (agent: life-engineer)
- **daily-energy-audit**: Track energy levels throughout the day, identify drains and sources (agent: life-engineer)
- **daily-focus-session**: Deep work execution — isolate environment, single-thread execution (agent: life-engineer)
- **daily-system-boot**: Morning system boot sequence — state initialization, day architecture design (agent: life-engineer)
- **daily-system-shutdown**: Evening system shutdown sequence — metrics collection, log analysis (agent: life-engineer)
- **explain-logic**: Trace and explain the execution flow of a specific code path
- **fix-bug**: Systematically diagnose and fix bugs in the codebase (agent: bug-hunter)
- **get-docs**: Fetch latest documentation for a library using available documentation tools
- **life-baseline-update**: Recompute baselines from all accumulated life-journal time-series and event data (agent: life-engineer)
- **life-decision-log**: Log significant decisions with rationale and follow-up schedule (agent: life-engineer)
- **life-incident-response**: Crisis handling protocol for emotional/relationship/failure incidents (agent: life-engineer)
- **life-journal-init**: Initialize the Life Systems Engineering journal (agent: life-engineer)
- **life-metrics-query**: Query accumulated life-journal data — trends, aggregates, patterns (agent: life-engineer)
- **optimize-performance**: Identify and fix performance bottlenecks with evidence-based analysis (agent: performance-optimizer)
- **refactor-feature**: Refactor code for clarity and maintainability without changing behavior (agent: feature-builder)
- **review-architecture**: Review code strictly against project architecture rules and call out violations (agent: code-reviewer)
- **review-pr**: Review code for quality, consistency, and architectural compliance (agent: code-reviewer)
- **update-docs**: Update project documentation to match current codebase state (agent: doc-keeper)
- **weekly-life-architecture-review**: Weekly retrospective — aggregate daily metrics, review architecture debt (agent: life-engineer)
