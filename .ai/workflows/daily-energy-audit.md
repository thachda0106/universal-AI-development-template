---
description: Track energy levels throughout the day, identify drains and sources, optimize allocation for peak performance
agent: life-engineer
---

# Daily Energy Audit

Map your energy expenditure and recovery patterns. Identify what drains your system and what charges it. Optimize energy allocation across activities based on empirical data.

> **When**: End of day or when you notice significant energy fluctuation.
> **Duration**: 5-10 minutes.
> **Analog**: Power profiling — measure wattage per process, identify power-hungry processes, optimize allocation.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — ENERGY DATA COLLECTION

**No analysis. Raw collection only.**

Map today's energy landscape:

1. **Hourly energy reconstruction**: For each major block of the day (morning/afternoon/evening), estimate energy level (1-10) and the primary activity.
2. **Peak energy time**: When was your energy highest? What were you doing?
3. **Low energy time**: When was your energy lowest? What preceded it?
4. **Recovery periods**: When did you take breaks? How effective were they (1-10)?
5. **Energy drains**: List activities that seemed to consume more energy than expected.
6. **Energy sources**: List activities that boosted or restored energy.
7. **Sleep debt**: Hours of sleep last night vs. your optimal. How does this correlate with today's energy?

**Reference**: `develop-life/part-1-foundations.md` Ch5 (Energy Management); `develop-life/part-4-performance.md` Ch3 (Stress Management), Ch7 (Recovery Systems)

**Output**: `SCRATCHPAD.md` with energy data

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Energy Data Collection) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to drain analysis, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — DRAIN & SOURCE ANALYSIS

**Scratchpad must be APPROVED. No action yet.**

### 2.0 Historical Pattern Read

Read `C:\personal_sources\find-jobs\life-journal\time-series\energy.csv` for last 7 days.
Read `C:\personal_sources\find-jobs\life-journal\time-series\sleep.csv` for last 7 days.

**Pattern detection**: Scan historical data for recurring patterns:
- Do energy drops consistently follow specific activities?
- Does sleep quality correlate with next-day energy?
- Are there day-of-week energy patterns?

Include findings in analysis.

Analyze the data to identify patterns:

1. **Drain categorization**: For each drain, categorize:
   - **Cognitive drain**: Complex problem-solving, decision-making, learning new material
   - **Emotional drain**: Social interactions, conflict, emotional labor, performance anxiety
   - **Physical drain**: Exercise, illness, poor sleep, hunger, sedentary fatigue
   - **Environmental drain**: Noise, clutter, interruptions, temperature, screen exposure
2. **Source categorization**: For each energy source, categorize:
   - **Restorative**: Sleep, naps, breaks, nature
   - **Social**: Meaningful connection (differs from draining social)
   - **Creative**: Flow state, making progress, solving interesting problems
   - **Physical**: Exercise (paradoxical — energy spent = energy gained), nutrition, hydration
3. **Drain/source ratio**: What is the ratio of energy drained to energy restored today?
4. **Pattern identification**: Are there recurring drain patterns across multiple days? (This week, what consistently drains?)

**Output**: `PLAN.md` with analysis findings

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Drain Analysis) complete. Please review PLAN.md.
Reply APPROVE to continue to optimization, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — ALLOCATION OPTIMIZATION

**Plan must be APPROVED.**

Design energy-aware adjustments:

1. **Schedule alignment**: Based on identified energy peaks/troughs, adjust tomorrow's schedule:
   - High-cognitive tasks → peak energy windows
   - Low-cognitive tasks → trough energy windows
   - Recovery → scheduled after known drains
2. **Drain mitigation**: For each significant drain, identify a mitigation:
   - Cognitive drain → shorter sessions, more breaks, better preparation
   - Emotional drain → boundary setting, recovery protocols, social energy budgeting
   - Physical drain → nutrition timing, movement breaks, sleep improvement
   - Environmental drain → workspace optimization, noise cancellation, focus tools
3. **Source maximization**: For each energy source, how can you get more of it?
4. **Capacity planning**: What is tomorrow's predicted workload? Do you have the energy capacity for it? If not, what gets deprioritized?

---

## PHASE 4 — LOGGING

Log energy audit results:

```markdown
## Energy Audit Log: [Date]

### Energy Curve
- Morning: [energy] — [primary activity]
- Afternoon: [energy] — [primary activity]
- Evening: [energy] — [primary activity]
- Peak: [time] @ [energy level]
- Trough: [time] @ [energy level]

### Drains
| Activity | Type | Severity (1-10) | Duration | Mitigation |
|----------|------|-----------------|----------|------------|
| [drain] | [C/E/P/Env] | [1-10] | [time] | [plan] |

### Sources
| Activity | Type | Effectiveness (1-10) | Optimization |
|----------|------|---------------------|-------------|
| [source] | [R/S/C/P] | [1-10] | [plan] |

### Optimization Commitments
1. [Tomorrow's energy-aware adjustment]
2. [Drain mitigation to implement]
3. [Source to maximize]

### Sleep Impact
- Hours slept: [hours]
- Energy correlation: [observation]
```

### 4.1 Notes to Journal

Energy data is primarily captured by `/daily-system-shutdown` (energy.csv appends). This audit adds:
- Drain/source analysis appended to today's daily file at `C:\personal_sources\find-jobs\life-journal\daily\YYYY-MM-DD.md` as a note
- Optimization commitments recorded for weekly review context

### 4.2 Git Commit

```bash
cd C:\personal_sources\find-jobs\life-journal
git add -A
git commit -m "energy-audit: YYYY-MM-DD"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Saved energy audit log entry + daily file updated + committed

---

// turbo
