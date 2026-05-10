# PLAN — Life Systems Engineering Daily Skills & Commands

## Architecture Overview

Create a new OpenCode capability comprising one agent, one skill, and nine commands that operationalize the Life Systems Engineering documentation into daily actionable practices.

### Dependency Graph

```
life-engineering-daily-practices (skill)
        │
        ▼
  life-engineer (agent)
        │
        ├──► daily-system-boot (command)
        ├──► daily-system-shutdown (command)
        ├──► daily-focus-session (command)
        ├──► daily-emotional-observability (command)
        ├──► daily-cognitive-scan (command)
        ├──► daily-energy-audit (command)
        ├──► weekly-life-architecture-review (command)
        ├──► life-incident-response (command)
        └──► life-decision-log (command)
```

---

## 1. Skill Architecture: `life-engineering-daily-practices`

### Structure

```
skills/life-engineering-daily-practices/
├── SKILL.md          — Master skill definition
└── references/       (optional, for future expansion)
```

### SKILL.md Front-Matter

```yaml
name: life-engineering-daily-practices
description: Apply software engineering principles to daily life systems management, emotional debugging, and personal architecture.
category: personal-development
inputs:
  - current_emotional_state
  - energy_levels
  - attention_budget
  - goals_for_day
outputs:
  - daily_plan
  - system_health_report
  - reflection_log
  - action_items
```

### Body Sections
- **When to Use**: Daily life systems engineering
- **Core Concepts**: Extracted from all 8 parts of the series
- **Daily Practice Areas**: Morning boot, evening shutdown, focus sessions, emotional observability, cognitive scanning, energy management, incident response, weekly architecture review, decision logging
- **Engineering Analogies**: Mapping table (observability→self-awareness, logging→journaling, etc.)
- **Step-by-Step Procedures**: For each practice area
- **Decision Rules**: When to use which command
- **Outputs**: Expected artifacts from each practice
- **Reference Map**: Links to specific chapters in develop-life/

---

## 2. Agent Architecture: `life-engineer`

### File: `agents/life-engineer.md`

**Front-Matter**:
```yaml
name: life-engineer
description: Execute Life Systems Engineering daily practices — system boot, emotional observability, cognitive scanning, energy management, incident response, and architecture review
skills:
  - life-engineering-daily-practices
  - analyze-project-structure
  - diagnose-bug-root-cause
boundaries:
  - NEVER give generic self-help advice
  - NEVER use motivational language
  - ALWAYS use engineering/system frameworks
  - ALWAYS reference develop-life documentation
```

**Body Sections**:
- **Role**: Life Systems Engineer — applies engineering thinking to human life
- **Core Philosophy**: Human life as complex adaptive system, event-driven architecture, distributed system with unreliable inputs
- **Execution Rules**: Multi-phase workflow, structured analysis, system-first approach
- **Tool Usage**: Read (develop-life docs), Write (journal entries), Question (diagnostic), Bash (system tracking scripts)
- **Forbidden**: Motivational language, generic advice, shallow productivity tips

---

## 3. Commands Architecture (9 files)

All commands follow the same architecture pattern:

### Standard Command Template

```yaml
---
description: <one-line description>
agent: life-engineer
---
# <Title>

<Brief context about when to use this command>

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — DIAGNOSIS/OBSERVE

**No plans or actions. Data collection only.**

1. Collect current state data (questions tailored to domain)
2. Reference relevant develop-life chapter(s)
3. Write findings into scratchpad

**Output**: `SCRATCHPAD.md`

### 🛑 HARD STOP — APPROVAL GATE 1

---

## PHASE 2 — ANALYSIS

1. Analyze collected data
2. Apply frameworks from develop-life
3. Identify patterns, anomalies, opportunities
4. Write plan

**Output**: `PLAN.md`

### 🛑 HARD STOP — APPROVAL GATE 2

---

## PHASE 3 — EXECUTION

1. Execute the planned actions
2. Implement changes
3. Write results

---

## PHASE 4 — LOGGING

1. Record outcomes
2. Export to journal/metrics

---

// turbo
```

### Command-Specific Details

| Command | Phase 1 Focus | Phase 2 Framework | Phase 3 Actions | Key develop-life References |
|---------|--------------|-------------------|-----------------|---------------------------|
| `daily-system-boot` | Current state: sleep, energy, mood, calendar | Day architecture, intention setting, priority triage | Execute morning plan, set up environment | P1 Ch1 (OS), P1 Ch4 (Attention), P4 Ch8 (Routines) |
| `daily-system-shutdown` | Log metrics: energy, focus, emotions, decisions | Day review, pattern analysis, preparation | Journal, plan tomorrow, prepare sleep | P1 Ch5 (Energy), P4 Ch6-7 (Sleep, Recovery) |
| `daily-focus-session` | Current context, distractions, task queued | Focus protocol: isolate, single-thread, execute | Deep work block with environment config | P4 Ch1 (Deep Focus), P1 Ch4 (Attention) |
| `daily-emotional-observability` | Emotional state metrics, triggers, events | Anomaly detection, pattern identification | Log emotions, identify triggers, regulate | P5 Ch1 (Regulation), Special 2 (Observability), P5 Ch2-3 |
| `daily-cognitive-scan` | Recent thoughts, decisions, reactions | Distortion catalog matching, bias detection | Log distortions, reframe, calibrate | P2 Ch5 (Cognitive Distortions), P3 Ch4-5 (Probabilistic/Bayesian) |
| `daily-energy-audit` | Hourly energy logs, activity mapping | Drain analysis, allocation optimization | Plan energy-aware schedule, identify patterns | P1 Ch5 (Energy), P4 Ch3 (Stress) |
| `weekly-life-architecture-review` | Weekly metrics: energy, focus, emotions, completed | Trend analysis, debt identification, strategy | Plan next week, set goals, refactor | P2 Ch1 (RCA), P8 Ch3 (Planning), Special 3,7 |
| `life-incident-response` | Crisis description, symptoms, severity | Triage, containment, root cause | Execute runbook, stabilize, postmortem | Special 1 (Incident Response), Special 9 |
| `life-decision-log` | Decision context, options, criteria | Decision tree, expected value, Bayesian update | Log decision, rationale, review outcome | P2 Ch8 (Decision Trees), P3 Ch4-5 |

---

## 4. File Creation Order

Implementation must follow this dependency order:

1. **SKILL** `life-engineering-daily-practices/SKILL.md` — no dependencies, foundational knowledge
2. **AGENT** `life-engineer.md` — depends on skill existing
3. **COMMANDS** — depend on agent existing
   3a. `daily-system-boot.md` (core daily practice)
   3b. `daily-system-shutdown.md` (core daily practice)
   3c. `daily-focus-session.md` (core daily practice)
   3d. `daily-emotional-observability.md` (health practice)
   3e. `daily-cognitive-scan.md` (health practice)
   3f. `daily-energy-audit.md` (health practice)
   3g. `weekly-life-architecture-review.md` (weekly practice)
   3h. `life-incident-response.md` (on-demand)
   3i. `life-decision-log.md` (on-demand)

---

## 5. Edge Cases & Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| User doesn't have daily energy for 9 practices | Commands are independent; use subset. Focus on boot+shutdown+focus as minimum viable |
| Self-help tone creeps in | Add explicit constraint: "Forbidden: motivational language" in agent boundaries |
| Too much overhead for daily use | Commands are designed to be 5-15 min each; boot+shutdown pair takes ~20 min/day |
| Commands feel like chores | Each command includes a "Why This Matters" explanation with engineering analogy |
| Missing context from develop-life | Each command references specific chapters for deep dives |

---

## 6. Quality Gates

Before declaring done:
- [ ] All files have valid YAML front-matter
- [ ] All command files have multi-phase structure
- [ ] All command files have hard-stop approval gates
- [ ] Agent file references only existing skills
- [ ] Commands reference only existing agent
- [ ] No motivational/shallow language in any file
- [ ] Each file follows existing OpenCode format conventions
