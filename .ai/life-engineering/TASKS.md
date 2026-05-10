# TASKS — Life Systems Engineering Daily Skills & Commands

## Ordered Implementation Steps

Implementation order follows the dependency chain: **Skill → Agent → Commands**.
Commands ordered by daily usage frequency (core first, then health, then weekly, then on-demand).

---

### Task 1: Create Skill — `life-engineering-daily-practices`

**File to create**: `C:\Users\thach\.config\opencode\skills\life-engineering-daily-practices\SKILL.md`

**Dependencies**: None (foundational)

**Content requirements**:
- YAML front-matter with name, description, category (personal-development), inputs, outputs
- `## When to Use` section
- `## Core Philosophy` section — the engineering-first mindset
- `## Engineering Analogy Reference Table` — mapping software engineering → life concepts
- `## Daily Practice Areas` — 9 practice areas with brief descriptions
- `## Step-by-Step Procedures` — for each practice area
- `## Decision Rules` — when to use which command
- `## Reference Map` — mapping commands to develop-life chapters
- `## Non-Goals` — what this skill is NOT for

**Quality checks**:
- [ ] Valid YAML front-matter
- [ ] No motivational language
- [ ] Engineering analogies throughout
- [ ] Each practice area has a clear procedure

---

### Task 2: Create Agent — `life-engineer`

**File to create**: `C:\Users\thach\.config\opencode\agents\life-engineer.md`

**Dependencies**: Task 1 (references the skill)

**Content requirements**:
- YAML front-matter: name, description, skills list [life-engineering-daily-practices, analyze-project-structure], boundaries list
- `## Role` — Life Systems Engineer definition
- `## Core Philosophy` — the engineering-first mindset quote from the series
- `## Execution Rules` — how to execute daily practices
- `## Tool Usage (Generic)` — tools and their life-engineering mapping
- `## Forbidden` — explicit constraints against motivational/self-help language

**Quality checks**:
- [ ] Valid YAML front-matter
- [ ] Skills list references only existing skills + the new one
- [ ] Boundaries are clear and enforceable
- [ ] Follows same format as other agent files

---

### Task 3: Create Command — `daily-system-boot`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-system-boot.md`

**Dependencies**: Task 2 (references life-engineer agent)

**Description**: Morning system boot sequence — state initialization, day architecture, intention setting

**Phase structure**:
- Phase 1 — **Boot Diagnostics**: Collect current state (sleep quality, energy level 1-10, current mood, calendar scan, top 3 priorities)
- Phase 2 — **Day Architecture**: Design day structure, allocate attention budget, set intention
- Phase 3 — **System Initialization**: Execute boot sequence, configure environment
- Phase 4 — **Logging**: Record boot sequence data to journal

**Key references**: P1 Ch1 (Human OS), P1 Ch4 (Attention), P4 Ch8 (Routines), P1 Ch5 (Energy)

---

### Task 4: Create Command — `daily-system-shutdown`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-system-shutdown.md`

**Dependencies**: Task 2

**Description**: Evening shutdown sequence — metrics collection, reflection, recovery preparation

**Phase structure**:
- Phase 1 — **Metrics Collection**: Collect daily metrics (energy curve, focus quality, emotional range, decisions made, accomplishments)
- Phase 2 — **Log Analysis**: Review day's data, identify patterns, note anomalies
- Phase 3 — **Recovery Preparation**: Prepare for next day, set up environment for sleep, clear mental cache
- Phase 4 — **Journal Write**: Write structured journal entry with collected metrics

**Key references**: P1 Ch5 (Energy), P4 Ch6 (Sleep), P4 Ch7 (Recovery), Special 2 (Observability)

---

### Task 5: Create Command — `daily-focus-session`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-focus-session.md`

**Dependencies**: Task 2

**Description**: Deep work execution — isolate, single-thread, maximize throughput

**Phase structure**:
- Phase 1 — **Context Assessment**: Current cognitive load, task queue, interruptions, environment
- Phase 2 — **Focus Protocol**: Select single task, set timebox, configure environment, eliminate interrupts
- Phase 3 — **Execution**: Run deep work block with execution monitoring
- Phase 4 — **Review**: Log focus quality, output, distractions, adjust protocol

**Key references**: P4 Ch1 (Deep Focus), P1 Ch4 (Attention), P4 Ch5 (Cognitive Load)

---

### Task 6: Create Command — `daily-emotional-observability`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-emotional-observability.md`

**Dependencies**: Task 2

**Description**: Emotional state check — collect metrics, detect anomalies, log events

**Phase structure**:
- Phase 1 — **Emotional Metrics Collection**: Current emotional state, recent triggers, body sensations, thought patterns
- Phase 2 — **Anomaly Detection**: Compare to baseline, identify deviations, detect emotional events
- Phase 3 — **Regulation Protocol**: If anomaly detected → select regulation strategy; if normal → log and continue
- Phase 4 — **Event Logging**: Log emotional state, trigger context, regulation response, outcome

**Key references**: P5 Ch1 (Regulation), Special 2 (Observability), P5 Ch2 (Fear/Anxiety), P5 Ch4 (Social Pressure)

---

### Task 7: Create Command — `daily-cognitive-scan`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-cognitive-scan.md`

**Dependencies**: Task 2

**Description**: Scan for cognitive distortions and biases in recent thinking

**Phase structure**:
- Phase 1 — **Thought Collection**: Recent significant thoughts, decisions, reactions, beliefs in play
- Phase 2 — **Distortion Catalog Matching**: Check each thought against catalog of common distortions (all-or-nothing, catastrophizing, mind-reading, etc.)
- Phase 3 — **Reframing**: For each detected distortion, apply reframing technique
- Phase 4 — **Calibration Log**: Log detected distortions, frequency, severity, reframes applied

**Key references**: P2 Ch5 (Cognitive Distortions), P3 Ch4 (Probabilistic Thinking), P3 Ch5 (Bayesian Reasoning)

---

### Task 8: Create Command — `daily-energy-audit`

**File to create**: `C:\Users\thach\.config\opencode\commands\daily-energy-audit.md`

**Dependencies**: Task 2

**Description**: Track energy levels, identify drains, optimize allocation

**Phase structure**:
- Phase 1 — **Energy Data Collection**: Hourly energy levels, activities, context, recovery periods
- Phase 2 — **Drain Analysis**: Identify energy drains vs. sources, pattern matching
- Phase 3 — **Optimization Plan**: Energy-aware scheduling, drain mitigation, capacity planning
- Phase 4 — **Metrics Logging**: Log daily energy patterns for trend analysis

**Key references**: P1 Ch5 (Energy), P4 Ch3 (Stress Management), P4 Ch7 (Recovery Systems)

---

### Task 9: Create Command — `weekly-life-architecture-review`

**File to create**: `C:\Users\thach\.config\opencode\commands\weekly-life-architecture-review.md`

**Dependencies**: Task 2

**Description**: Weekly retrospective — trend analysis, debt identification, next week architecture

**Phase structure**:
- Phase 1 — **Weekly Metrics Aggregation**: Aggregate daily metrics (energy avg, focus avg, emotional stability, decisions made, patterns)
- Phase 2 — **Architecture Review**: Identify architecture debt, pattern analysis, trend detection
- Phase 3 — **Strategy Planning**: Design next week's architecture, set goals, plan refactoring
- Phase 4 — **System Update**: Write weekly report, update goals, adjust systems

**Key references**: P2 Ch1 (RCA), P8 Ch3 (Planning), Special 3 (Architecture Debt), Special 7 (Life Refactoring), P3 Ch6 (Compounding)

---

### Task 10: Create Command — `life-incident-response`

**File to create**: `C:\Users\thach\.config\opencode\commands\life-incident-response.md`

**Dependencies**: Task 2

**Description**: Crisis handling for emotional/relationship/failure incidents

**Phase structure**:
- Phase 1 — **Incident Triage**: Severity assessment (SEV1-3), symptoms, immediate safety, stabilization
- Phase 2 — **Root Cause Analysis**: Trace incident chain, identify trigger, distinguish symptom from cause
- Phase 3 — **Resolution & Recovery**: Execute runbook, apply fix, restore stability
- Phase 4 — **Post-Incident Review**: Write postmortem, identify system improvements, update runbook

**Key references**: Special 1 (Incident Response), Special 9 (Production Failures), P2 Ch1 (RCA), P5 Ch6 (Resilience)

---

### Task 11: Create Command — `life-decision-log`

**File to create**: `C:\Users\thach\.config\opencode\commands\life-decision-log.md`

**Dependencies**: Task 2

**Description**: Log important decisions with rationale, expected values, and outcome tracking

**Phase structure**:
- Phase 1 — **Decision Context**: Decision description, options, timeframe, stakes
- Phase 2 — **Analysis**: Decision tree, expected value calculation, Bayesian prior, opportunity cost
- Phase 3 — **Decision Record**: Log chosen option, rationale, predicted outcome, confidence level
- Phase 4 — **Follow-up Schedule**: Set follow-up date to compare predicted vs. actual outcome

**Key references**: P2 Ch8 (Decision Trees), P3 Ch4 (Probabilistic Thinking), P3 Ch5 (Bayesian), P3 Ch7 (Opportunity Cost)

---

## Dependency Graph

```
Task 1 (Skill) ──► Task 2 (Agent) ──┬──► Task 3 (boot)
                                     ├──► Task 4 (shutdown)
                                     ├──► Task 5 (focus)
                                     ├──► Task 6 (emotional)
                                     ├──► Task 7 (cognitive)
                                     ├──► Task 8 (energy)
                                     ├──► Task 9 (weekly)
                                     ├──► Task 10 (incident)
                                     └──► Task 11 (decision)
```

Tasks 3-11 are independent of each other and can be written in parallel after Task 2 is complete.

---

## Implementation Summary

| # | Task | File | Type | Est. Size |
|---|------|------|------|-----------|
| 1 | Create skill | `skills/life-engineering-daily-practices/SKILL.md` | New | ~150 lines |
| 2 | Create agent | `agents/life-engineer.md` | New | ~80 lines |
| 3 | Create boot command | `commands/daily-system-boot.md` | New | ~100 lines |
| 4 | Create shutdown command | `commands/daily-system-shutdown.md` | New | ~100 lines |
| 5 | Create focus command | `commands/daily-focus-session.md` | New | ~80 lines |
| 6 | Create emotional command | `commands/daily-emotional-observability.md` | New | ~90 lines |
| 7 | Create cognitive command | `commands/daily-cognitive-scan.md` | New | ~90 lines |
| 8 | Create energy command | `commands/daily-energy-audit.md` | New | ~80 lines |
| 9 | Create weekly command | `commands/weekly-life-architecture-review.md` | New | ~100 lines |
| 10 | Create incident command | `commands/life-incident-response.md` | New | ~90 lines |
| 11 | Create decision command | `commands/life-decision-log.md` | New | ~80 lines |
| | **Total** | **11 files** | | **~1,050 lines** |
