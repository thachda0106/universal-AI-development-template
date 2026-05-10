# SCRATCHPAD — Life Systems Engineering Daily Skills & Commands

## Overview

Create a set of OpenCode skills, agent, and slash commands that operationalize the "Life Systems Engineering" documentation series into daily actionable practices. These tools go into `C:\Users\thach\.config\opencode\`.

---

## Requirements Analysis

### What the User Asked
> "From this knowledge, create commands and skills for work on every single day I need do."

### Source Knowledge
- Location: `C:\personal_sources\find-jobs\develop-life\`
- 10 files spanning ~950 KB of deep engineering-first content about human life as a system
- 8 major parts + special topics covering: foundations, debugging, mental models, performance, emotional engineering, relationships, career, meaning, and 12 advanced topics

### Target Output Location
- `C:\Users\thach\.config\opencode\agents\` — agent definitions
- `C:\Users\thach\.config\opencode\skills\` — skill knowledge bundles
- `C:\Users\thach\.config\opencode\commands\` — slash-command workflows

---

## Existing Structure Analysis

### Agent Files (`agents/`)
| File | Role |
|------|------|
| `bug-hunter.md` | Systematic debugging |
| `code-reviewer.md` | Code quality review |
| `doc-keeper.md` | Documentation maintenance |
| `feature-builder.md` | New feature implementation |
| `performance-optimizer.md` | Performance analysis |
| `test-engineer.md` | Test generation |

**Pattern**: Each agent has YAML front-matter with `name`, `description`, `skills`, `boundaries`. Then a markdown body with `## Role`, `## Execution Rules`, `## Tool Usage (Generic)`.

### Skill Files (`skills/*/SKILL.md`)
| Skill | Description |
|-------|-------------|
| `analyze-project-structure` | Map project architecture |
| `apply-targeted-fix` | Surgical code changes |
| `diagnose-bug-root-cause` | Root cause analysis |
| `locate-code-patterns` | Find syntax patterns |
| `trace-execution-flow` | Follow data/logic paths |
| `validate-architecture` | Check architecture rules |
| `verify-bug-regression` | Run tests/checks |

**Pattern**: Each skill has YAML front-matter with `name`, `description`, `category`, `inputs`, `outputs`. Body has `## When to Use`, `## Step-by-Step Procedure`, `## Decision Rules`, `## Outputs`, `## Non-Goals`.

### Command Files (`commands/*.md`)
| Command | Agent | Purpose |
|---------|-------|---------|
| `create-feature.md` | feature-builder | New feature creation |
| `fix-bug.md` | bug-hunter | Debug & fix |
| `add-tests.md` | test-engineer | Test generation |
| `review-architecture.md` | code-reviewer | Architecture review |
| `explain-logic.md` | * | Code explanation |
| `get-docs.md` | * | Documentation |
| `optimize-performance.md` | performance-optimizer | Performance |
| `refactor-feature.md` | feature-builder | Refactoring |
| `update-docs.md` | doc-keeper | Documentation updates |
| `review-pr.md` | code-reviewer | PR review |
| `build-large-system.md` | feature-builder | Large system build |
| `build-minimum-system.md` | feature-builder | MVP build |
| `ai-workflow.md` | * | AI workflow |
| `add-api-integration.md` | feature-builder | API integration |
| `build-large-system-phases-*.md` | feature-builder | Phased builds |

**Pattern**: Each command has YAML front-matter with `description` and `agent`. Body has `# Title`, then multi-phase workflow with `## PHASE N — NAME`, hard stop approval gates, and turbo section.

---

## Content to Create

### 1. New Agent: `life-engineer`

A specialized agent for executing Life Systems Engineering daily practices. References the develop-life documentation as its knowledge base.

**Skills needed**: life-engineering-daily-practices, analyze-project-structure (for self-reflection), diagnose-bug-root-cause (for personal debugging)

### 2. New Skill: `life-engineering-daily-practices`

The core knowledge skill that encodes the daily practice frameworks from the develop-life series into an executable skill format.

### 3. New Commands (Daily/Weeksly Practices)

Drawing from the develop-life content, these are the essential daily practices:

| # | Command | Based On (Parts) | Purpose | Frequency |
|---|---------|-----------------|---------|-----------|
| 1 | `daily-system-boot` | P1 Ch1-4 (OS, Cognitive, Attention, Energy) | Morning startup sequence: state init, day plan, intention setting | Daily AM |
| 2 | `daily-system-shutdown` | P1 Ch5 (Energy), P4 Ch6-7 (Sleep, Recovery) | Evening wind-down: journaling, metrics, review, prepare | Daily PM |
| 3 | `daily-focus-session` | P4 Ch1 (Deep Focus), P1 Ch4 (Attention) | Deep work execution: isolate, single-thread, execute | Daily |
| 4 | `daily-emotional-observability` | P5 Ch1 (Regulation), Special Topic 2 (Observability) | Emotional state check: collect metrics, detect anomalies | Daily (2-3x) |
| 5 | `daily-cognitive-scan` | P2 Ch5 (Cognitive Distortions), P3 Ch4-5 (Probabilistic/Bayesian) | Scan for distortions, biases, logical fallacies | Daily (mid-day) |
| 6 | `daily-energy-audit` | P1 Ch5 (Energy), P4 Ch3 (Stress) | Track energy levels, identify drains, optimize allocation | Daily (end of day) |
| 7 | `weekly-life-architecture-review` | P2 Ch1 (RCA), P8 Ch3 (Planning), Special Topics 3,7 | Weekly retro, metrics review, refactoring plan | Weekly |
| 8 | `life-incident-response` | Special Topic 1 (Incident Response), Special Topic 9 (Production Failures) | Crisis handling: emotional, conflict, failure | On-demand |
| 9 | `life-decision-log` | P3 Ch4-5 (Probabilistic/Bayesian), P2 Ch8 (Decision Trees) | Log important decisions with rationale, review outcomes | On-demand |

---

## Key Design Decisions

1. **No motivational language** — all content uses engineering/system terminology
2. **Phase-based workflow** — matches existing OpenCode command pattern
3. **Referenced knowledge** — commands reference specific chapters/sections
4. **Approval gates** — follow the same human-checkpoint pattern
5. **Minimal scope** — one agent, one skill, nine commands

## Risk Analysis

- **Risk**: Commands too open-ended → mitigated by structured phases with specific outputs
- **Risk**: Self-help tone creeping in → mitigated by engineering-first language requirement
- **Risk**: Too many commands → user can start with core 3-4 and add others as needed
- **Risk**: Format mismatch with existing patterns → mitigated by following exact existing formats

---

## Verification Plan

After creation:
1. Verify all files exist in correct directories
2. Verify YAML front-matter syntax
3. Verify command files follow phase structure
4. Verify skill includes all required sections
5. Verify agent references correct skills

---

## Directory Map

```
C:\Users\thach\.config\opencode\
├── agents\
│   └── life-engineer.md              (NEW)
├── skills\
│   └── life-engineering-daily-practices\   (NEW)
│       └── SKILL.md
├── commands\
│   ├── daily-system-boot.md              (NEW)
│   ├── daily-system-shutdown.md          (NEW)
│   ├── daily-focus-session.md            (NEW)
│   ├── daily-emotional-observability.md  (NEW)
│   ├── daily-cognitive-scan.md           (NEW)
│   ├── daily-energy-audit.md             (NEW)
│   ├── weekly-life-architecture-review.md(NEW)
│   ├── life-incident-response.md         (NEW)
│   └── life-decision-log.md              (NEW)
```
